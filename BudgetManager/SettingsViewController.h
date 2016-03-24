//
//  SettingsViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wallet;

@interface SettingsViewController : UITableViewController

@property (strong,nonatomic) Wallet* selectedWallet;
@property (weak, nonatomic) IBOutlet UITextField *walletNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *secureSwitch;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
- (IBAction)actionSecureSwitch:(UISwitch *)sender;
- (IBAction)actionDeleteButton:(UIBarButtonItem *)sender;

@end
