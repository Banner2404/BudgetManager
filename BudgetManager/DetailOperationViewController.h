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
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moneyTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *profitTypeControl;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
- (IBAction)actionMoneyTypeControl:(UISegmentedControl *)sender;
- (IBAction)actionDateChanged:(UIDatePicker *)sender;
- (IBAction)actionEditButton:(UIBarButtonItem *)sender;


@end
