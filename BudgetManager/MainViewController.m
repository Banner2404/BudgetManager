//
//  MainViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

#pragma mark - Actions

- (IBAction)actionSettings:(UIButton *)sender {
    
    if (!self.selectedWallet) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No wallet"
                                                                       message:@"Please select wallet you want to configure"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:nil completion:nil];
    
    }else{
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        SettingsViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        
        vc.selectedWallet = self.selectedWallet;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
