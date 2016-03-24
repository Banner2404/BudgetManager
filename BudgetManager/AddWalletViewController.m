//
//  AddWalletViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 24.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "AddWalletViewController.h"
#import "MainViewController.h"
#import "DatabaseManager.h"
#import "Wallet.h"

@interface AddWalletViewController ()

@end

@implementation AddWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkSequre];
    
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
        
    }else{
        
        [self.passwordTextField setHidden:YES];
        [self.passwordLabel setHidden:YES];
        
        
        
    }
    
}

#pragma mark - Actions

- (IBAction)actionSecureSwitch:(UISwitch *)sender {
        
    [self checkSequre];
    
}

- (IBAction)actionDoneButton:(UIBarButtonItem *)sender {
    
    NSString* name = self.walletNameTextField.text;
    NSInteger cash = [self.cashMoneyTextLabel.text integerValue];
    NSInteger bank = [self.bankMoneyTextLabel.text integerValue];
    BOOL isSecure = self.secureSwitch.isOn;
    NSString* password = self.passwordTextField.text;

    [[DatabaseManager sharedManager] createWalletWithName:name
                                                     cash:cash
                                                     bank:bank
                                                 security:isSecure
                                                 password:password];
    
    [[DatabaseManager sharedManager] saveContext];
    
    MainViewController* mainVC = [[self.navigationController viewControllers] objectAtIndex:0];
    
    [mainVC refreshInfo];

    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
