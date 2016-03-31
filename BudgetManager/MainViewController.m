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

#pragma mark - Actions

- (IBAction)actionSettings:(UIButton *)sender {
    
    [self showViewControllerFromStoryboardID:@"SettingsViewController"];
}


- (IBAction)actionAdd:(UIButton *)sender {
    
    [self showViewControllerFromStoryboardID:@"AddOperationViewController"];

}

- (IBAction)actionStatictics:(UIButton *)sender {
    
    [self showViewControllerFromStoryboardID:@"StatisticsViewController"];

    
}
@end
