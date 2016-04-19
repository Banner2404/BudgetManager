//
//  AddOperationViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 25.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "AddOperationViewController.h"
#import "DatabaseManager.h"
#import "TypesViewController.h"
#import "DateViewController.h"

@interface AddOperationViewController () <UITextFieldDelegate>

@property (assign,nonatomic) NSInteger cost;
@property (assign,nonatomic) NSInteger moneyType;
@property (assign,nonatomic) NSInteger profitType;

@end

@implementation AddOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
    
    self.navigationItem.backBarButtonItem.title = @"Назад";
    
    if (self.selectedType) {
        self.typeTextField.text = self.selectedType.name;
    }
    if (self.cost) {
        
        self.costTextField.text = [NSString stringWithFormat:@"%ld",self.cost];
        
    }
    if (self.moneyType) {
        
        self.moneyTypeControl.selectedSegmentIndex = self.moneyType;
        
    }
    
    if (self.profitType) {
        
        self.profitTypeControl.selectedSegmentIndex = self.profitType;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDateController{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    DateViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"DateViewController"];
    
    vc.operationVC = self;
    vc.datePicker.date = self.selectedDate;
    
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = self.typeTextField;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)loadTypesController{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    TypesViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"TypesViewController"];
    
    vc.operationVC = self;
    
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = self.typeTextField;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (BOOL)numberField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet* charactersSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if ([[string componentsSeparatedByCharactersInSet:charactersSet] count] > 1) {
        return NO;
    }
    return YES;
}

- (void)showAlertWithTitle:(NSString*) title message:(NSString*) message actionName:(NSString*) actionName{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    if (actionName) {
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:actionName
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        
        [alert addAction:action];

    }
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    
}

- (void)validAddOperation{
    
    [[DatabaseManager sharedManager] addOperationForWallet:self.selectedWallet
                                                      type:self.selectedType
                                                      cost:[self.costTextField.text integerValue]
                                                 moneyType:(OperationMoneyType)self.moneyTypeControl.selectedSegmentIndex
                                                profitType:(OperationProfitType)self.profitTypeControl.selectedSegmentIndex
                                                      date:self.selectedDate];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)validAddFavourites{
    
    Operation* operation = [NSEntityDescription insertNewObjectForEntityForName:@"Operation" inManagedObjectContext:[[DatabaseManager sharedManager] managedObjectContext]];
    
    NSInteger cost = [self.costTextField.text integerValue];
    
    OperationMoneyType moneyType = (OperationMoneyType)self.moneyTypeControl.selectedSegmentIndex;
    OperationProfitType profitType = (OperationProfitType)self.profitTypeControl.selectedSegmentIndex;
    
    operation.wallet = self.selectedWallet;
    operation.type = self.selectedType;
    operation.cost = [NSNumber numberWithInteger:cost];
    operation.moneyType = [NSNumber numberWithInteger:moneyType];
    operation.profitType = [NSNumber numberWithInteger:profitType];
    
    [[DatabaseManager sharedManager] addOperationInFavourites:operation];

    
}

- (void)setCost:(NSInteger)cost moneyType:(NSInteger)moneyType profitType:(NSInteger)profitType{
    
    self.cost = cost;
    self.moneyType = moneyType;
    self.profitType = profitType;
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.typeTextField]) {
        
        [self.costTextField resignFirstResponder];
        [self loadTypesController];
        return NO;
        
    }
    
    if ([textField isEqual:self.dateTextField]){
        
        [self.costTextField resignFirstResponder];
        [self loadDateController];
        return NO;
        
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.costTextField]){
        
        return [self numberField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark - Actions

- (IBAction)actionFavouritesButton:(UIBarButtonItem *)sender {
    
    if (!self.selectedType) {
        
        [self showAlertWithTitle:@"Type" message:@"Please select type of operation" actionName:@"OK"];
        
    }else{
        
        [self validAddFavourites];
        [self showAlertWithTitle:@"Favourites" message:@"Operation has been added to favourites" actionName:nil];

    }
    
}

- (IBAction)actionAddButton:(UIButton *)sender {
    
    if (!self.selectedType) {
        
        [self showAlertWithTitle:@"Type" message:@"Please select type of operation" actionName:@"OK"];
        
    }else if([self.costTextField.text isEqualToString:@""]){
        
        [self showAlertWithTitle:@"Cost" message:@"Please enter cost of operation" actionName:@"OK"];
        
    }else{
        
        [self validAddOperation];
    }
    
    
    
    
}

- (IBAction)actionProfitTypeControl:(UISegmentedControl *)sender {
    
    self.selectedType = nil;
    self.typeTextField.text = @"";
    [self.typeTextField becomeFirstResponder];
    
}
@end
