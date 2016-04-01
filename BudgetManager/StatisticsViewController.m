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

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSSortDescriptor*)getSortDescriptorForSortType:(SortType)sortType{
    
    NSSortDescriptor* descriptor;
    if (sortType == SortTypeName) {
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
    }else if(sortType == SortTypeCost){
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"cost" ascending:NO];
    }else{
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    }
    
    return descriptor;
    
}

- (void)updateFetchedResultsController{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Operation" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"wallet.name == %@",self.selectedWallet.name];
    
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [self getSortDescriptorForSortType:SortTypeName];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",operation.cost];
    
}

#pragma mark - Actions

- (IBAction)actionFilterButton:(UIBarButtonItem *)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    FilterViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];

    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    Operation* operation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    DetailOperationViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailOperationViewController"];
 
    vc.selectedOperation = operation;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
