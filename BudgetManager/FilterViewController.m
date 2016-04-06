//
//  FilterViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 01.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkEnables];

    
    
}

- (void)checkEnables{
    
    self.moneyTypeControl.enabled = self.moneyTypeSwitch.isOn ? YES:NO;
    self.profitTypeControl.enabled = self.profitTypeSwitch.isOn ? YES:NO;
    for (UILabel* label in  self.costLabels) {
        
        label.enabled = self.costSwitch.isOn ? YES:NO;
        
    }
    for (UITextField* textField in  self.costTextFields) {
        
        textField.enabled = self.costSwitch.isOn ? YES:NO;
        
    }
    for (UILabel* label in  self.dateLabels) {
        
        label.enabled = self.dateSwitch.isOn ? YES:NO;
        
    }
    for (UITextField* textField in  self.dateTextFields) {
        
        textField.enabled = self.dateSwitch.isOn ? YES:NO;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
