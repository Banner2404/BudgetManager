//
//  DateViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 29.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddOperationViewController;

@interface DateViewController : UIViewController

@property (weak,nonatomic) AddOperationViewController* operationVC;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)actionDoneButton:(UIBarButtonItem *)sender;

@end
