//
//  SettingsViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainViewController.h"
#import "DatabaseManager.h"
#import "Wallet.h"

@interface SettingsViewController () <UITextFieldDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.walletNameTextField.text = self.selectedWallet.name;
    [self.secureSwitch setOn:[self.selectedWallet.isSecure boolValue]];
    self.passwordTextField.text = self.selectedWallet.password;
    self.cashMoneyTextField.text = [NSString stringWithFormat:@"%@",self.selectedWallet.cashMoney];
    self.bankMoneyTextField.text = [NSString stringWithFormat:@"%@",self.selectedWallet.bankMoney];

    
    [self checkSequre];
    
    NSLog(@"%@", self.walletNameTextField.text);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkSequre{
    
    if (self.secureSwitch.isOn) {
        
        [self.passwordTextField setHidden:NO];
        [self.passwordLabel setHidden:NO];
        
    }else{
        
        [self.passwordTextField setHidden:YES];
        [self.passwordLabel setHidden:YES];

        
        
    }
    
}

- (void)deleteWallet{
    
    [[DatabaseManager sharedManager] deleteWallet:self.selectedWallet];
    
    self.selectedWallet = nil;
    
    MainViewController* mainVC = [[self.navigationController viewControllers] objectAtIndex:0];
    
    mainVC.selectedWallet = nil;
    
    [mainVC refreshInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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


#pragma mark - Actions

- (IBAction)actionSecureSwitch:(UISwitch *)sender {
    
    self.selectedWallet.isSecure = [NSNumber numberWithBool:sender.isOn];
    
    [self checkSequre];
    
}

- (IBAction)actionDeleteButton:(UIBarButtonItem *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete wallet"
                                                                   message:[NSString stringWithFormat:@"Are you sure want to delete wallet %@", self.selectedWallet.name]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionYes = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self deleteWallet];
                                                      }];
    UIAlertAction* actionNo = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.cashMoneyTextField] || [textField isEqual:self.cashMoneyTextField]) {
        
        return [self numberField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    if ([textField isEqual:self.walletNameTextField] || [textField isEqual:self.passwordTextField]) {
        
        return [self nameField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    return YES;
    
}

@end
