//
//  DetailOperationViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 31.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Operation;

@interface DetailOperationViewController : UITableViewController

@property (strong,nonatomic) Operation* selectedOperation;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;


@end
