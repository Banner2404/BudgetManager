//
//  MainViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "AddOperationViewController.h"
#import "StatisticsViewController.h"
#import "FavouritesViewController.h"
#import "DetailOperationViewController.h"
#import "AddWalletViewController.h"
#import "DatabaseManager.h"

@interface MainViewController ()

@property (strong,nonatomic) NSDate* selectedDate;
@property (strong,nonatomic) NSArray* loadedOperations;

@end

@implementation MainViewController

static const NSInteger secInDay = 86400;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCurrentDate];
    [self setDate];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger selectedWalletID = [defaults integerForKey:@"selectedWalletID"];
    
    self.selectedWallet = [[DatabaseManager sharedManager] getWalletWithID:selectedWalletID];
    
    if (!self.selectedWallet) {
        [self addFirstWallet];
    }
    [self.tableView reloadData];
    [self refreshInfo];

}

- (void)addFirstWallet{
    
    if ([[[DatabaseManager sharedManager] getWallets] count]){
        
        self.selectedWallet = [[[DatabaseManager sharedManager] getWallets] firstObject];
        return;
        
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Новый кошелек"
                                                                   message:@"Введите имя кошелька"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField* alertTextField = [[UITextField alloc] init];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        alertTextField = textField;
        
    }];
    
    UIAlertAction* actionDone = [UIAlertAction
                                 actionWithTitle:@"Готово"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * _Nonnull action) {
                                     
                                     self.selectedWallet = [[DatabaseManager sharedManager]
                                                            createWalletWithName:alertTextField.text
                                                            cash:0
                                                            bank:0
                                                            security:NO
                                                            password:nil];
                                     [self refreshInfo];

                                 }];
    
    [alert addAction:actionDone];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)setCurrentDate{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = nil;
    
    components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    self.selectedDate = [calendar dateFromComponents:components];

}

- (void)saveWallet{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:[self.selectedWallet.walletID integerValue] forKey:@"selectedWalletID"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self refreshInfo];
    [self setDate];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDate{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"d MMMM"];
    
    NSString* date = [formatter stringFromDate:self.selectedDate];
    
    [self.dateButton setTitle:date forState:UIControlStateNormal];
    
}

- (void)refreshInfo{
    
    if (self.selectedWallet) {
        
        [self.walletButton setTitle:self.selectedWallet.name forState:UIControlStateNormal];
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyAccountingStyle;
        
        
        self.cashMoneyLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:self.selectedWallet.cashMoney]];
        self.cashMoneyLabel.textColor = [UIColor whiteColor];

        self.bankMoneyLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:self.selectedWallet.bankMoney]];
        self.bankMoneyLabel.textColor = [UIColor whiteColor];
        
    }else{
        
        [self.walletButton setTitle:@"No wallet" forState:UIControlStateNormal];
        self.cashMoneyLabel.text = @"0 $";
        self.cashMoneyLabel.textColor = [UIColor whiteColor];
        self.bankMoneyLabel.text = @"0 $";
        self.bankMoneyLabel.textColor = [UIColor whiteColor];

    }

    
}

- (void)loadDailyOperations{
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Operation" inManagedObjectContext:[[DatabaseManager sharedManager] managedObjectContext]];
    
    NSPredicate* walletPredicate = [NSPredicate predicateWithFormat:@"wallet.name == %@",self.selectedWallet.name];
    
    NSPredicate* datePredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@",self.selectedDate,[self.selectedDate dateByAddingTimeInterval:secInDay]];
    
    NSCompoundPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[walletPredicate,datePredicate]];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    
    [request setSortDescriptors:@[descriptor]];
    
    self.loadedOperations = [[[DatabaseManager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
    
}

- (void)updateDate{
    [self setDate];
    
    [self.tableView beginUpdates];
    
    [self loadDailyOperations];

    NSInteger oldRowsCount = [self.tableView numberOfRowsInSection:0];
    NSInteger newRowsCount = [self.loadedOperations count];
    
    NSMutableArray* deleteIndexPaths = [NSMutableArray array];
    NSMutableArray* insertIndexPaths = [NSMutableArray array];

    
    for (int i = 0;  i < oldRowsCount; i ++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];

        [deleteIndexPaths addObject:indexPath];
    }
    for (int i = 0;  i < newRowsCount; i ++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [insertIndexPaths addObject:indexPath];
    }
    
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
    
}

#pragma mark - Actions


- (IBAction)actionRightSwipe:(UISwipeGestureRecognizer *)sender {
    
    self.selectedDate = [self.selectedDate dateByAddingTimeInterval:-secInDay];
    [self updateDate];

}

- (IBAction)actionLeftSwipe:(UISwipeGestureRecognizer *)sender {
    self.selectedDate = [self.selectedDate dateByAddingTimeInterval:secInDay];
    [self updateDate];

}

- (IBAction)actionLongPress:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan && !self.tableView.isEditing) {
        [self.tableView setEditing:YES animated:YES];

    }else if (sender.state == UIGestureRecognizerStateBegan && self.tableView.isEditing) {
        
        [self.tableView setEditing:NO animated:YES];
        
    }
}

- (IBAction)actionDateButton:(UIButton *)sender {
    
    [self setCurrentDate];
    [self updateDate];
    
}

#pragma mark - Segues


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier  isEqualToString: @"statisticsSegue"]) {
        
        StatisticsViewController* vc = segue.destinationViewController;
        vc.selectedWallet = self.selectedWallet;
        
    }else if ([segue.identifier  isEqualToString: @"favouritesSegue"]){
        
        FavouritesViewController* vc = segue.destinationViewController;
        vc.selectedWallet = self.selectedWallet;
        
    }else if ([segue.identifier  isEqualToString: @"settingsSegue"]){
        
        SettingsViewController* vc = segue.destinationViewController;
        vc.selectedWallet = self.selectedWallet;
        
    }else if ([segue.identifier  isEqualToString: @"addOperationSegue"]){
        
        AddOperationViewController* vc = segue.destinationViewController;
        vc.selectedWallet = self.selectedWallet;
        
    }else if([segue.identifier  isEqualToString: @"detailOperationSegue"]){
        
        DetailOperationViewController* vc = segue.destinationViewController;
        NSInteger index = [[self.tableView indexPathForSelectedRow] row];
        vc.selectedOperation = [self.loadedOperations objectAtIndex:index];
        
    }else if([segue.identifier isEqualToString:@"walletsSegue"]){
        
        
    }
}
- (IBAction)prepareForUnwind:(UIStoryboardSegue*)segue{
    
    AddWalletViewController* vc = segue.sourceViewController;
    NSString* name = vc.walletNameTextField.text;
    NSInteger cash = [vc.cashMoneyTextField.text integerValue];
    NSInteger bank = [vc.bankMoneyTextField.text integerValue];
    BOOL isSecure = vc.secureSwitch.isOn;
    NSString* password = vc.passwordTextField.text;
    
    self.selectedWallet = [[DatabaseManager sharedManager] createWalletWithName:name
                                                     cash:cash
                                                     bank:bank
                                                 security:isSecure
                                                 password:password];
    
    [[DatabaseManager sharedManager] saveContext];

    [self refreshInfo];
}

#pragma mark - UITableViewDelegate

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"Удалить";
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self loadDailyOperations];
    if ([self.loadedOperations count] == 0) {
        
        [self.emptyView setHidden:NO];
        
    }else{
        [self.emptyView setHidden:YES];

    }
    return [self.loadedOperations count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Operation* operation = [self.loadedOperations objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UIImageView* imageView = [cell.contentView viewWithTag:1];
    if ([[[DatabaseManager sharedManager] defaultOperationTypes] objectForKey:operation.type.name]) {
        imageView.image =
        [UIImage imageNamed:[[[DatabaseManager sharedManager] defaultOperationTypes] objectForKey:operation.type.name]];
    }else
        imageView.image = [UIImage imageNamed:@"other"];
    
    UIImageView* moneyImage = [cell.contentView viewWithTag:4];
    if ([operation.moneyType integerValue] == OperationMoneyTypeCash) {
        moneyImage.image = [UIImage imageNamed:@"cash"];
    }else
        moneyImage.image = [UIImage imageNamed:@"bank"];

    UILabel* textLabel = [cell.contentView viewWithTag:2];
    textLabel.text = operation.type.name;
    UILabel* detailTextLabel = [cell.contentView viewWithTag:3];
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyAccountingStyle;

    if ([operation.profitType integerValue] == OperationProfitTypeIncome) {
        detailTextLabel.text = [NSString stringWithFormat:@"+ %@",[formatter stringFromNumber:operation.cost]];
    }else{
        detailTextLabel.text = [NSString stringWithFormat:@"- %@",[formatter stringFromNumber:operation.cost]];
    }
    detailTextLabel.textColor = [UIColor colorWithRed:53.f/256 green:147.f/256 blue:127.f/256 alpha:1];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView beginUpdates];
    Operation* operation = [self.loadedOperations objectAtIndex:indexPath.row];
    
    [[DatabaseManager sharedManager] deleteOperation:operation];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    
    [tableView endUpdates];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.isEditing) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}


@end
