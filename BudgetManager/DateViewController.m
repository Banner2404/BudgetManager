//
//  DateViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 29.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DateViewController.h"
#import "AddOperationViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionDoneButton:(UIBarButtonItem *)sender {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.operationVC.selectedDate = self.datePicker.date;
    self.operationVC.dateTextField.text = [formatter stringFromDate:self.datePicker.date];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
