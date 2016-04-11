//
//  StatisticsViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 31.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "StatisticsViewController.h"
#import "DetailOperationViewController.h"
#import "FilterViewController.h"
#import "Wallet.h"
#import "Operation.h"
#import "OperationType.h"

@interface StatisticsViewController () <UITableViewDelegate>

@end

@implementation StatisticsViewController

@synthesize fetchedResultsController = _fetchedResultsController;

static const int secInWeek = 604800;
static const int secInMonth = 2592000;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self updateFetchedResultsController];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSSortDescriptor*)getSortDescriptorForSortType:(FilterSortType)sortType ascending:(BOOL) asceding{
    
    NSSortDescriptor* descriptor;
    if (sortType == FilterSortTypeName) {
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:asceding];
    }else if(sortType == FilterSortTypeCost){
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"cost" ascending:asceding];
    }else{
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:asceding];
    }
    
    return descriptor;
    
}

- (NSMutableString*)getFormatStringForMoneyType:(FilterMoneyType)moneyType profitType:(FilterProfitType)profitType minCost:(NSInteger) minCost maxCost:(NSInteger)maxCost{
    
    
    NSMutableString* format = [NSMutableString string];
    
    [format appendFormat:@"wallet.name == '%@'",self.selectedWallet.name];
    
    
    if (moneyType != FilterMoneyTypeNone) {
        
        
        [format appendFormat:@" AND moneyType == %u",moneyType - 1];
        
    }
    
    if (profitType != FilterProfitTypeNone) {
        
        
        [format appendFormat:@" AND profitType == %u",profitType - 1];
        
    }
    
    if (minCost != 0 || maxCost != 0) {
        
        [format appendFormat:@" AND (cost >= %ld AND cost <= %ld)",minCost,maxCost];
        
    }
    
    return format;
    
}

- (void)updateFetchedResultsController{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Operation" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableString* format = [self
                        getFormatStringForMoneyType:(FilterMoneyType)[self.filterVC.moneyTypeControl selectedSegmentIndex]
                                          profitType:(FilterProfitType)[self.filterVC.profitTypeControl selectedSegmentIndex]
                                          minCost:self.filterVC.minCost
                                          maxCost:self.filterVC.maxCost];
    
    
    
    NSPredicate* firstPredicate = [NSPredicate predicateWithFormat:format];
    
    NSPredicate* secondPredicate = nil;
    
    if ([self.filterVC.dateControl selectedSegmentIndex] == FilterDateTypeWeek) {
        secondPredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@",[NSDate dateWithTimeIntervalSinceNow:-secInWeek], [NSDate dateWithTimeIntervalSinceNow:0]];
    }else if ([self.filterVC.dateControl selectedSegmentIndex] == FilterDateTypeMonth){
        secondPredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@",[NSDate dateWithTimeIntervalSinceNow:-secInMonth], [NSDate dateWithTimeIntervalSinceNow:0]];
    }
    
    NSArray* predicates = [NSArray arrayWithObjects:firstPredicate, secondPredicate, nil];
    
    NSCompoundPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    
    NSSortDescriptor* sortDescriptor;
    if (!self.filterVC) {
        sortDescriptor = [self getSortDescriptorForSortType:FilterSortTypeDate ascending:NO];
    }else{
        sortDescriptor = [self
          getSortDescriptorForSortType:(FilterSortType)[[self.filterVC.sortTypeControl objectAtIndex:0] selectedSegmentIndex]
          ascending:(BOOL)[[self.filterVC.sortTypeControl objectAtIndex:1] selectedSegmentIndex]];
    }
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    [self updateFetchedResultsController];
    
    return _fetchedResultsController;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object{
    
    Operation* operation = (Operation*)object;
    
    cell.textLabel.text = operation.type.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ $",operation.cost];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([operation.profitType integerValue] == OperationProfitTypeIncome) {
        cell.detailTextLabel.textColor = [UIColor greenColor];
    }else{
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
}

#pragma mark - Actions

- (IBAction)actionFilterButton:(UIBarButtonItem *)sender {
    
    if (!self.filterVC) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        self.filterVC = [storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
    }
    
    [self.navigationController pushViewController:self.filterVC animated:YES];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Operation* operation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    DetailOperationViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailOperationViewController"];
 
    vc.selectedOperation = operation;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
