//
//  AddOperationViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 25.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wallet;
@class OperationType;

@interface AddOperationViewController : UITableViewController

@property (strong,nonatomic) Wallet* selectedWallet;
@property (strong,nonatomic) OperationType* selectedType;
@property (strong,nonatomic) NSDate* selectedDate;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moneyTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *profitTypeControl;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
- (IBAction)actionAddButton:(UIButton *)sender;

@end
