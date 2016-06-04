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

@interface AddOperationViewController () <UITextFieldDelegate>

@property (assign,nonatomic) NSInteger cost;
@property (assign,nonatomic) NSInteger moneyType;
@property (assign,nonatomic) NSInteger profitType;
@property (assign,nonatomic) NSInteger datePickerCellHeight;

@end

static const NSInteger datePickerShownHeight = 216;
static const NSInteger datePickerHiddenHeight = 0;


@implementation AddOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    self.datePickerCellHeight = 0;
    
    self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
    
    self.navigationItem.backBarButtonItem.title = @"Назад";
        
    if (self.selectedType) {
        self.typeTextField.text = self.selectedType.name;
    }
    
    if (self.isLoadFromFavourites) {
        self.costTextField.text = [NSString stringWithFormat:@"%ld",self.cost];
        self.moneyTypeControl.selectedSegmentIndex = self.moneyType;
        self.profitTypeControl.selectedSegmentIndex = self.profitType;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        self.selectedType = nil;
        textField.text = @"";
        [self.costTextField resignFirstResponder];
        [self loadTypesController];
        return NO;
        
    }
    
    if ([textField isEqual:self.dateTextField]){
        
        [self.costTextField resignFirstResponder];
        //[self loadDateController];
        
        [self.tableView beginUpdates];
        
        if (self.datePickerCellHeight == datePickerHiddenHeight) {
            self.datePickerCellHeight = datePickerShownHeight;
            [self.datePicker setHidden:NO];

        }else{
            self.datePickerCellHeight = datePickerHiddenHeight;
            [self.datePicker setHidden:YES];
        }
        
        [self.tableView endUpdates];
        
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5) {
        return self.datePickerCellHeight;
    }else{
        return self.tableView.rowHeight;
    }
    
}

#pragma mark - Actions

- (IBAction)actionDateChanged:(UIDatePicker *)sender {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateTextField.text = [formatter stringFromDate:self.datePicker.date];
    self.selectedDate = self.datePicker.date;
        
}

- (IBAction)actionFavouritesButton:(UIBarButtonItem *)sender {
    
    if (!self.selectedType) {
        
        [self showAlertWithTitle:@"Категория" message:@"Выберите катогорию" actionName:@"OK"];
        
    }else{
        
        [self validAddFavourites];
        [self showAlertWithTitle:@"Избранное" message:@"Операция добавлена в избранное" actionName:nil];

    }
    
}

- (IBAction)actionAddButton:(UIButton *)sender {
    
    if (!self.selectedType) {
        
        [self showAlertWithTitle:@"Категория" message:@"Выберите категорию" actionName:@"OK"];
        
    }else if([self.costTextField.text isEqualToString:@""]){
        
        [self showAlertWithTitle:@"Стоимость" message:@"Введите стоимость операции" actionName:@"OK"];
        
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
