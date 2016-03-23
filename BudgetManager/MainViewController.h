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

@property (strong,nonatomic) Wallet* selectedWallet;
- (IBAction)actionSettings:(UIButton *)sender;

@end
