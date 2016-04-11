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
    
    self.navigationItem.title = @"Filter";


    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    UITextField* textField = [self.costTextField objectAtIndex:0];
    
    self.minCost = [textField.text integerValue];
    
    textField = [self.costTextField objectAtIndex:1];
    
    self.maxCost = [textField.text integerValue];

    
    if (self.maxCost < self.minCost) {
        self.minCost = 0;
    }    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet* charactersSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if ([[string componentsSeparatedByCharactersInSet:charactersSet] count] > 1) {
        return NO;
    }
    return YES;
 
    
}

@end
