//
//  MainViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "AddOperationViewController.h"
#import "Wallet.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshInfo];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self refreshInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshInfo{
    
    if (self.selectedWallet) {
        
        [self.walletButton setTitle:self.selectedWallet.name forState:UIControlStateNormal];
        self.cashMoneyLabel.text = [NSString stringWithFormat:@"%@",self.selectedWallet.cashMoney];
        self.bankMoneyLabel.text = [NSString stringWithFormat:@"%@",self.selectedWallet.bankMoney];
        
        
    }else{
        
        [self.walletButton setTitle:@"No wallet" forState:UIControlStateNormal];
        self.cashMoneyLabel.text = @"0";
        self.bankMoneyLabel.text = @"0";
    }

    
}

- (void)showWalletAlert{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No wallet"
                                                                   message:@"Please select wallet you want to configure"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:nil completion:nil];
    
}

- (void)showViewControllerFromStoryboardID:(NSString*)storyboardID{
    
    if (!self.selectedWallet) {
        
        [self showWalletAlert];
        
    }else{
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        SettingsViewController* vc = [storyboard instantiateViewControllerWithIdentifier:storyboardID];
        
        vc.selectedWallet = self.selectedWallet;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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

- (void)validSettingsLoad{
    
    [self showViewControllerFromStoryboardID:@"SettingsViewController"];
    
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
        
        UIAlertAction* actionDone = [UIAlertAction
                                   actionWithTitle:@"Done"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * _Nonnull action) {
                                               
                                               if ([passwordTextField.text isEqualToString:self.selectedWallet.password]) {
                                                   
                                                   [self validSettingsLoad];
                                                   
                                               }else{
                                                   
                                                   [self showAlertWithTitle:@"Error"
                                                                    message:@"Incorrect password"
                                                                 actionName:@"OK"];
                                                   
                                               }
                                               
                                           }];
        
        [alert addAction:actionDone];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        [self validSettingsLoad];
        
    }
}


#pragma mark - Actions

- (IBAction)actionSettings:(UIButton *)sender {

    [self checkPassword];
}


- (IBAction)actionAdd:(UIButton *)sender {
    
    [self showViewControllerFromStoryboardID:@"AddOperationViewController"];

}

- (IBAction)actionStatictics:(UIButton *)sender {
    
    [self showViewControllerFromStoryboardID:@"StatisticsViewController"];

    
}
@end
