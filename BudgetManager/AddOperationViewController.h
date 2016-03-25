//
//  AddOperationViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 25.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wallet;

@interface AddOperationViewController : UITableViewController

@property (strong,nonatomic) Wallet* selectedWallet;

@end
