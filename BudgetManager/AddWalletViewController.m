//
//  AddWalletViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 24.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "AddWalletViewController.h"
#import "DatabaseManager.h"
#import "Wallet.h"

@interface AddWalletViewController () <UITextFieldDelegate>

@property (assign,nonatomic) NSInteger passwordRowHeight;

@end

static const NSInteger passwordShownHeight = 44;
static const NSInteger passwordHiddenHeight = 0;

@implementation AddWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    [self checkSequre];
    
    [self.walletNameTextField becomeFirstResponder];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkSequre{
    
    if (self.secureSwitch.isOn) {
        
        [self.passwordTextField setHidden:NO];
        [self.passwordLabel setHidden:NO];
        self.bankMoneyTextField.returnKeyType = UIReturnKeyNext;
        [self.tableView beginUpdates];
        
        self.passwordRowHeight = passwordShownHeight;
        
        [self.tableView endUpdates];
        
    }else{
        
        [self.passwordTextField setHidden:YES];
        [self.passwordLabel setHidden:YES];
        self.bankMoneyTextField.returnKeyType = UIReturnKeyDone;
        [self.tableView beginUpdates];
        
        self.passwordRowHeight = passwordHiddenHeight;
        
        [self.tableView endUpdates];

        
    }
    
}

- (BOOL)nameField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet* charactersSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    if ([[string componentsSeparatedByCharactersInSet:charactersSet] count] > 1) {
        return NO;
    }
    return YES;
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

#pragma mark - Actions

- (IBAction)actionSecureSwitch:(UISwitch *)sender {
    
    if ([self.passwordTextField isFirstResponder]) {
        
        [self.passwordTextField resignFirstResponder];
        
    }
    
    [self checkSequre];
    
}

#pragma mark - Segues

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString:@"unwindSegueToMainController"]) {
        
        if ([self.walletNameTextField.text isEqualToString:@""]) {
            
            [self showAlertWithTitle:@"Name" message:@"Please enter name for wallet" actionName:@"OK"];
            return NO;
            
        }else if (self.secureSwitch.isOn && [self.passwordTextField.text isEqualToString:@""]) {
            
            [self showAlertWithTitle:@"Password" message:@"Please enter password for wallet" actionName:@"OK"];
            return NO;
            
        }else{
            
            return YES;
            
        }
        
        
    }else
        return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.cashMoneyTextField] || [textField isEqual:self.bankMoneyTextField]) {
        
        return [self numberField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    if ([textField isEqual:self.walletNameTextField] || [textField isEqual:self.passwordTextField]) {
        
        return [self nameField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isEqual:self.walletNameTextField]){
        
        [self.cashMoneyTextField becomeFirstResponder];
        
    }else if ([textField isEqual:self.cashMoneyTextField]){
        
        [self.bankMoneyTextField becomeFirstResponder];
        
    }else if ([textField isEqual:self.bankMoneyTextField]){
        
        [textField resignFirstResponder];
        
        if (self.secureSwitch.isOn) {
            
            [self.passwordTextField becomeFirstResponder];
            
        }
        
    }else{
        
        [textField resignFirstResponder];
        
    }
    return YES;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 4) {
        return self.passwordRowHeight;
    }else{
        return self.tableView.rowHeight;
    }
    
}

@end
