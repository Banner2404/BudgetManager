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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)actionDoneButton:(UIBarButtonItem *)sender {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.operationVC.selectedDate = self.datePicker.date;
    self.operationVC.dateTextField.text = [formatter stringFromDate:self.datePicker.date];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
