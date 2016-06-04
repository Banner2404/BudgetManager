//
//  StatisticsViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 31.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "StatisticsViewController.h"
#import "DatabaseManager.h"
#import "DiagramView.h"

@interface StatisticsViewController () <UITableViewDelegate>

@property (strong,nonatomic) NSArray* data;
@property (strong,nonatomic) NSArray* filteredData;
@property (strong,nonatomic) NSArray* colors;
@property (strong,nonatomic) NSDate* currentDate;
@property (assign,nonatomic) OperationTypeProfitType profitType;

@end

@implementation StatisticsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.diagramView.selectedSegmentIndex = -1;
    self.profitType = OperationTypeProfitTypeExpence;
    [self.intervalControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self setCurrentDate];
    self.data = [self getDataForWallet:self.selectedWallet];
    self.filteredData = [self filteredDataFromData:self.data andWallet:self.selectedWallet];
    [self updateDataWithAnimation];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentDate{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = nil;
    
    components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    components.day ++;
    
    self.currentDate = [calendar dateFromComponents:components];
    
    
    
}

- (NSDate*)getStartDateForSegmentedControlIndex:(NSInteger)index fromCurrentDate:(NSDate*)date{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = nil;
    
    components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    switch (index) {
        case 0:
            components.day --;
            break;
        case 1:
            components.day -= 7;
            break;
        case 2:
            components.month --;
            break;
            
        default:
            break;
    }
    
    return [calendar dateFromComponents:components];
    
}




- (NSManagedObjectContext*)managedObjectContext{
    
    if (_managedObjectContext) {
        return _managedObjectContext;
    }else{
        _managedObjectContext = [[DatabaseManager sharedManager] managedObjectContext];
        return _managedObjectContext;
    }
    
}

- (void)updateData{
    
    NSMutableArray* diagramData = [NSMutableArray array];
    NSMutableArray* diagramColors = [NSMutableArray array];
    
    self.filteredData = [self filteredDataFromData:self.data andWallet:self.selectedWallet];
    
    NSInteger i = [self.filteredData count];
    CGFloat coeff = 1.f / i;
    
    
    for (OperationType* operationType in self.filteredData) {
        
        NSInteger cost = [self getCostForDate:self.currentDate
                                       wallet:self.selectedWallet
                                operationType:operationType];
        
        [diagramData addObject:[NSNumber numberWithInteger:cost]];
        
        [diagramColors addObject:[UIColor colorWithRed:53.f/256 green:147.f/256 blue:127.f/256 alpha:coeff * i--]];
        
    }
    
    self.diagramView.data = diagramData;
    self.diagramView.colors = diagramColors;
    self.colors = diagramColors;
    
    [self.diagramView setNeedsDisplay];
    [self.tableView reloadData];

    
}

- (void)updateDataWithAnimation{
    
    self.diagramView.selectedSegmentIndex = -1;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.diagramView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self updateData];
                         
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.diagramView.transform = CGAffineTransformIdentity;
                                          }];
                         
                     }];
    
}

- (NSInteger)getCostForDate:(NSDate*)date wallet:(Wallet*)wallet operationType:(OperationType*)operationType{
    
    NSDate* startDate = [self getStartDateForSegmentedControlIndex:[self.intervalControl selectedSegmentIndex]
                                                   fromCurrentDate:self.currentDate];
    
    NSInteger cost = [[DatabaseManager sharedManager]
                      getTotalCostForOperationType:operationType
                      andWallet:wallet
                      fromDate:startDate
                      toDate:self.currentDate];
    
    return cost;

}

- (NSArray*)filteredDataFromData:(NSArray*)data andWallet:(Wallet*)wallet{
    
    NSMutableArray* filteredData = [NSMutableArray arrayWithArray:data];
    
    [filteredData sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        OperationType* object1 = (OperationType*)obj1;
        OperationType* object2 = (OperationType*)obj2;
        
        NSInteger total1 = [self getCostForDate:self.currentDate
                                         wallet:self.selectedWallet
                                  operationType:object1];
        
        NSInteger total2 = [self getCostForDate:self.currentDate
                                         wallet:self.selectedWallet
                                  operationType:object2];
        
        if (total1 > total2) {
            return NSOrderedAscending;
        }else if (total2 > total1){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }

    }];
    
    
    for (OperationType* operationType in data) {
        
        NSInteger cost = [self getCostForDate:self.currentDate
                                       wallet:self.selectedWallet
                                operationType:operationType];
        if (cost == 0 || [operationType.profitType integerValue] != self.profitType) {
            [filteredData removeObject:operationType];
        }
    }
    
    return filteredData;

    
}

- (NSArray*)getDataForWallet:(Wallet*)wallet{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OperationType" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY operations.wallet.name == %@",wallet.name];
    
    [fetchRequest setPredicate:predicate];
    
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.filteredData count] == 0) {
        if (self.profitType == OperationTypeProfitTypeIncome) {
            self.emptyLabel.text = @"У вас нет приходных операций за ";
        }else{
            self.emptyLabel.text = @"У вас нет расходных операций за ";
        }
        
        switch ([self.intervalControl selectedSegmentIndex]) {
            case 0:
                self.emptyLabel.text = [self.emptyLabel.text stringByAppendingString:@"день"];
                break;
            case 1:
                self.emptyLabel.text = [self.emptyLabel.text stringByAppendingString:@"неделю"];
                break;
            case 2:
                self.emptyLabel.text = [self.emptyLabel.text stringByAppendingString:@"месяц"];
                break;

                
            default:
                break;
        }
        
        [self.emptyView setHidden:NO];

    }else{
        [self.emptyView setHidden:YES];

    }
    
    return [self.filteredData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    OperationType *object = [self.filteredData objectAtIndex:indexPath.row];
    [self configureCell:cell withObject:object atIndexPath:(NSIndexPath *)indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(OperationType *)operationType atIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView* imageView = [cell viewWithTag:1];
    
    if ([[[DatabaseManager sharedManager] defaultOperationTypes] objectForKey:operationType.name]) {
        imageView.image =
        [UIImage imageNamed:[[[DatabaseManager sharedManager] defaultOperationTypes] objectForKey:operationType.name]];
    }else
        imageView.image = [UIImage imageNamed:@"other"];

    UILabel* textLabel = [cell viewWithTag:2];
    textLabel.text = operationType.name;
    textLabel.textColor = [self.colors objectAtIndex:indexPath.row];
    
    UILabel* detailTextLabel = [cell viewWithTag:3];
    
    NSNumber* cost = [NSNumber numberWithInteger:[self getCostForDate:self.currentDate
                                                              wallet:self.selectedWallet
                                                       operationType:operationType]];
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyAccountingStyle;

    
    if (self.profitType == OperationTypeProfitTypeIncome) {
        detailTextLabel.text = [NSString stringWithFormat:@"+ %@",[formatter stringFromNumber:cost]];
    }else{
        detailTextLabel.text = [NSString stringWithFormat:@"- %@",[formatter stringFromNumber:cost]];
    }
    
    detailTextLabel.textColor = [UIColor colorWithRed:53.f/256 green:147.f/256 blue:127.f/256 alpha:1];
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView reloadData];
    
    self.diagramView.selectedSegmentIndex = indexPath.row;
    [self.diagramView setNeedsDisplay];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel* label = [cell viewWithTag:2];
    
    label.textColor = [UIColor colorWithRed:48.f/256 green:97.f/256 blue:117.f/256 alpha:1];
}


#pragma mark - Actions

- (IBAction)actionControl:(UISegmentedControl *)sender {
    
    [self updateDataWithAnimation];
    
}

- (IBAction)actionRightSwipe:(UISwipeGestureRecognizer *)sender {
    
    if ([self.intervalControl selectedSegmentIndex] > 0) {
        
        NSInteger index = [self.intervalControl selectedSegmentIndex];
        index--;
        
        self.intervalControl.selectedSegmentIndex = index;
        
        [self updateDataWithAnimation];
    }
    
}

- (IBAction)actionLeftSwipe:(UISwipeGestureRecognizer *)sender {
    if ([self.intervalControl selectedSegmentIndex] < 2) {
        
        NSInteger index = [self.intervalControl selectedSegmentIndex];
        index++;
        
        self.intervalControl.selectedSegmentIndex = index;
        
        [self updateDataWithAnimation];
    }

    
    
}

- (IBAction)actionProfitChange:(UIButton *)sender {
    
    if (self.profitType == OperationTypeProfitTypeIncome) {
        self.profitType = OperationTypeProfitTypeExpence;
        [sender setTitle:@"Расходы" forState:UIControlStateNormal];
    }else{
        self.profitType = OperationTypeProfitTypeIncome;
        [sender setTitle:@"Доходы" forState:UIControlStateNormal];
    }
    
    [self updateDataWithAnimation];
}
@end
