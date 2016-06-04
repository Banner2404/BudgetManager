//
//  FavoritesViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 13.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "FavouritesViewController.h"
#import "AddOperationViewController.h"
#import "DatabaseManager.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController

@synthesize fetchedResultsController = _fetchedResultsController;

static const CGFloat lightRedColor = 53.f/256;
static const CGFloat lightGreenColor = 147.f/256;
static const CGFloat lightBlueColor = 127.f/256;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];


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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    if ([sectionInfo numberOfObjects] == 0) {
        [self.emptyView setHidden:NO];
    }
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:object];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object{
    
    Operation* operation = (Operation*)object;
    
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
    detailTextLabel.textColor = [UIColor colorWithRed:lightRedColor green:lightGreenColor blue:lightBlueColor alpha:1];
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Operation* operation = (Operation*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    AddOperationViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"AddOperationViewController"];
    
    vc.selectedWallet = self.selectedWallet;
    vc.selectedType = operation.type;
    vc.isLoadFromFavourites = YES;
    
    [vc setCost:[operation.cost integerValue] moneyType:[operation.moneyType integerValue] profitType:[operation.profitType integerValue]];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"Удалить";
    
}



@end
