//
//  FavoritesViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 13.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "FavouritesViewController.h"
#import "AddOperationViewController.h"
#import "Operation.h"
#import "OperationType.h"
#import "Wallet.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Operation" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"favourite != nil AND wallet.name = %@",self.selectedWallet.name];

    [fetchRequest setPredicate:predicate];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Operation* operation = (Operation*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    AddOperationViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"AddOperationViewController"];
    
    vc.selectedWallet = self.selectedWallet;
    vc.selectedType = operation.type;

    [vc setCost:[operation.cost integerValue] moneyType:[operation.moneyType integerValue] profitType:[operation.moneyType integerValue]];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end