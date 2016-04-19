//
//  MainViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wallet;

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (strong,nonatomic) Wallet* selectedWallet;
@property (weak, nonatomic) IBOutlet UIButton *walletButton;
@property (weak, nonatomic) IBOutlet UILabel *cashMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankMoneyLabel;

- (void)refreshInfo;
- (void)saveWallet;
@end
