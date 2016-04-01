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

@end

@implementation AddOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:actionName
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)validAddOperation{
    
    [[DatabaseManager sharedManager] addOperationForWallet:self.selectedWallet
                                                      type:self.selectedType
                                                      cost:[self.costTextField.text integerValue]
                                                 moneyType:(MoneyType)self.moneyTypeControl.selectedSegmentIndex
                                                profitType:(ProfitType)self.profitTypeControl.selectedSegmentIndex
                                                      date:self.selectedDate];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)checkPassword{
    
    if ([self.selectedWallet.isSecure boolValue]) {
        
        NSLog(@"Password: %@ %@",self.selectedWallet.isSecure,self.selectedWallet.password);
        
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Password"
                                                                       message:@"Enter password for wallet"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        __block UITextField* passwordTextField = nil;
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.secureTextEntry = YES;
            
            passwordTextField = textField;
            
        }];
        
        UIAlertAction* actionDone = [UIAlertAction actionWithTitle:@"Done"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               if ([passwordTextField.text isEqualToString:self.selectedWallet.password]) {
                                                                   
                                                                   [self validAddOperation];
                                                               }else{
                                                                   
                                                                   [self showAlertWithTitle:@"Error"
                                                                                    message:@"Incorrect password"
                                                                                 actionName:@"OK"];
                                                                   
                                                               }
                                                               
                                                           }];
        
        [alert addAction:actionDone];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        [self validAddOperation];
        
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.typeTextField]) {
        
        [self loadTypesController];
        return NO;
        
    }
    
    if ([textField isEqual:self.dateTextField]){
        
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

#pragma mark - Actions

- (IBAction)actionAddButton:(UIButton *)sender {
    
    if (!self.selectedType) {
        
        [self showAlertWithTitle:@"Type" message:@"Please select type of operation" actionName:@"OK"];
        
    }else if([self.costTextField.text isEqualToString:@""]){
        
        [self showAlertWithTitle:@"Cost" message:@"Please enter cost of operation" actionName:@"OK"];
        
    }else{
        
        [self checkPassword];
        
    }
    
    
    
    
}
@end
