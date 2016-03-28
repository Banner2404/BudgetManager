//
//  AddOperationViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 25.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "AddOperationViewController.h"
#import "DatabaseManager.h"
#import "TypesViewController.h"

@interface AddOperationViewController () <UITextFieldDelegate>

@end

@implementation AddOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTypesController{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    TypesViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"TypesViewController"];
    
    vc.operationVC = self;
    
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = self.typeTextField;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.typeTextField]) {
        
        [self loadTypesController];
        return NO;
        
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)actionAddButton:(UIButton *)sender {
    
    [[DatabaseManager sharedManager] addOperationForWallet:self.selectedWallet
                                                      type:self.selectedType
                                                      cost:[self.costTextField.text integerValue]
                                                 moneyType:(MoneyType)self.moneyTypeControl.selectedSegmentIndex
                                                profitType:(ProfitType)self.profitTypeControl.selectedSegmentIndex
                                                      date:self.selectedDate];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
