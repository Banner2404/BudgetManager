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
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger selectedWalletID = [defaults integerForKey:@"selectedWalletID"];
    
    NSLog(@"load %ld",selectedWalletID);
    
    self.selectedWallet = [[DatabaseManager sharedManager] getWalletWithID:selectedWalletID];
    
    [self refreshInfo];
    [self setDate];
    
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
    NSLog(@"save %ld",[self.selectedWallet.walletID integerValue]);
    
}

- (void)viewWillAppear:(BOOL)animated{
    
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
        self.cashMoneyLabel.text = [NSString stringWithFormat:@"%@ $",self.selectedWallet.cashMoney];
        if ([self.selectedWallet.cashMoney integerValue] < 0) {
            self.cashMoneyLabel.textColor = [UIColor redColor];
        }else{
            self.cashMoneyLabel.textColor = [UIColor whiteColor];
        }
        self.bankMoneyLabel.text = [NSString stringWithFormat:@"%@ $",self.selectedWallet.bankMoney];
        if ([self.selectedWallet.bankMoney integerValue] < 0) {
            self.bankMoneyLabel.textColor = [UIColor redColor];
        }else{
            self.bankMoneyLabel.textColor = [UIColor whiteColor];
        }
        
        
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
    
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self loadDailyOperations];
    NSLog(@"count %ld",[self.loadedOperations count]);
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
    UILabel* textLabel = [cell.contentView viewWithTag:2];
    textLabel.text = operation.type.name;
    UILabel* detailTextLabel = [cell.contentView viewWithTag:3];
    detailTextLabel.text = [NSString stringWithFormat:@"%@ $",operation.cost];
    if ([operation.profitType integerValue] == OperationProfitTypeIncome) {
        detailTextLabel.textColor = [UIColor colorWithRed:53.f/256 green:147.f/256 blue:127.f/256 alpha:1];
        //detailTextLabel.textColor = [UIColor blueColor];
    }else{
        detailTextLabel.textColor = [UIColor colorWithRed:48.f/256 green:97.f/256 blue:117.f/256 alpha:1];
    }
    
    return cell;
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}


@end
