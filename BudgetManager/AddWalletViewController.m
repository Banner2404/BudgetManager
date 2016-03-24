//
//  AddWalletViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 24.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "AddWalletViewController.h"
#import "DatabaseManager.h"

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
    
    [[DatabaseManager sharedManager] createWalletWithName:self.walletNameTextField.text];
    
    [[DatabaseManager sharedManager] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
