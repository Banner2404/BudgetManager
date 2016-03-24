//
//  AddWalletViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 24.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWalletViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *walletNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *secureSwitch;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *cashMoneyTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankMoneyTextLabel;
- (IBAction)actionSecureSwitch:(UISwitch *)sender;
- (IBAction)actionDoneButton:(UIBarButtonItem *)sender;


@end
