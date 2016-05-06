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

@property (assign,nonatomic) NSInteger datePickerCellHeight;
@property (assign,nonatomic) BOOL isEditing;

@end

@implementation DetailOperationViewController

static const NSInteger datePickerShownHeight = 216;
static const NSInteger datePickerHiddenHeight = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    self.navigationItem.title = self.selectedOperation.type.name;
    
    self.typeLabel.text = self.selectedOperation.type.name;
    self.costTextField.text = [NSString stringWithFormat:@"%@",self.selectedOperation.cost];
    
    self.moneyTypeControl.selectedSegmentIndex = [self.selectedOperation.moneyType integerValue];
    self.profitTypeControl.selectedSegmentIndex = [self.selectedOperation.profitType integerValue];

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.dateTextField.text = [formatter stringFromDate:self.selectedOperation.date];
    self.datePicker.date = self.selectedOperation.date;
    self.idLabel.text = [NSString stringWithFormat:@"%@",self.selectedOperation.operationID];
    
    
}

- (BOOL)numberField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet* charactersSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if ([[string componentsSeparatedByCharactersInSet:charactersSet] count] > 1) {
        return NO;
    }
    
    NSInteger cost = [[textField.text stringByReplacingCharactersInRange:range withString:string] integerValue];
    
    self.selectedOperation.cost = [NSNumber numberWithInteger:cost];
    
    return YES;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.dateTextField]){
        
        if (!self.isEditing) {
            return NO;
        }
        
        [self.costTextField resignFirstResponder];
        //[self loadDateController];
        
        [self.tableView beginUpdates];
        
        if (self.datePickerCellHeight == datePickerHiddenHeight) {
            self.datePickerCellHeight = datePickerShownHeight;
            [self.datePicker setHidden:NO];
            
        }else{
            self.datePickerCellHeight = datePickerHiddenHeight;
            [self.datePicker setHidden:YES];
        }
        
        [self.tableView endUpdates];
        
        return NO;
        
    }
    
    if ([textField isEqual:self.costTextField] && !self.isEditing) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.costTextField]){
        
        return [self numberField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    return YES;
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5) {
        return self.datePickerCellHeight;
    }else{
        return self.tableView.rowHeight;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionMoneyTypeControl:(UISegmentedControl *)sender {
    
    self.selectedOperation.moneyType = [NSNumber numberWithInteger:sender.selectedSegmentIndex];
    
    
}


- (IBAction)actionDateChanged:(UIDatePicker *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateTextField.text = [formatter stringFromDate:self.datePicker.date];
    self.selectedOperation.date = self.datePicker.date;
}

- (IBAction)actionEditButton:(UIBarButtonItem *)sender {
    
    if (self.isEditing) {
        self.isEditing = NO;
        [sender setTitle:@"Изменить"];
        self.profitTypeControl.enabled = YES;
        self.typeLabel.enabled = YES;
        self.idLabel.enabled = YES;
        self.moneyTypeControl.userInteractionEnabled = NO;



    }else{
        self.isEditing = YES;
        [sender setTitle:@"Готово"];
        self.profitTypeControl.enabled = NO;
        self.typeLabel.enabled = NO;
        self.idLabel.enabled = NO;
        self.moneyTypeControl.userInteractionEnabled = YES;

    }
}
@end
