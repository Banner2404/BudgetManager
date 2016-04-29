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
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    self.navigationItem.title = self.selectedOperation.type.name;
    
    self.typeLabel.text = self.selectedOperation.type.name;
    self.costLabel.text = [NSString stringWithFormat:@"%@",self.selectedOperation.cost];
    self.moneyTypeLabel.text = [NSString stringWithFormat:@"%@",[self.selectedOperation.moneyType integerValue] == OperationMoneyTypeCash ? @"Наличные" : @"Безналичные" ];
    self.profitTypeLabel.text = [NSString stringWithFormat:@"%@",[self.selectedOperation.profitType integerValue] == OperationProfitTypeIncome ? @"Приход" : @"Расход" ];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.dateLabel.text = [formatter stringFromDate:self.selectedOperation.date];
    self.idLabel.text = [NSString stringWithFormat:@"%@",self.selectedOperation.operationID];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
