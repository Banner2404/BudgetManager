//
//  FilterViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 01.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UITableViewController

@property (strong, nonatomic) IBOutletCollection(UISegmentedControl) NSArray *sortTypeControl;

@property (weak, nonatomic) IBOutlet UISwitch *moneyTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *profitTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *costSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dateSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *moneyTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *profitTypeControl;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *costLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dateLabels;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *costTextFields;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *dateTextFields;

@end
