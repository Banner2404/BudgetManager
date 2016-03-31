//
//  DetailOperationViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 31.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DetailOperationViewController.h"
#import "Operation.h"
#import "OperationType.h"


@interface DetailOperationViewController ()

@end

@implementation DetailOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.typeLabel.text = self.selectedOperation.type.name;
    self.costLabel.text = [NSString stringWithFormat:@"%@",self.selectedOperation.cost];
    self.moneyTypeLabel.text = [NSString stringWithFormat:@"%@",[self.selectedOperation.moneyType integerValue] == MoneyTypeCash ? @"Cash" : @"Bank" ];
    self.profitTypeLabel.text = [NSString stringWithFormat:@"%@",[self.selectedOperation.profitType integerValue] == ProfitTypeIncome ? @"Income" : @"Expence" ];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.dateLabel.text = [formatter stringFromDate:self.selectedOperation.date];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
