//
//  TypesViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 25.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "TypesViewController.h"
#import "DatabaseManager.h"
#import "AddOperationViewController.h"
#import "OperationType.h"

@interface TypesViewController () <UITableViewDelegate>

@end

@implementation TypesViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DatabaseManager sharedManager] checkDefaultOperationTypes];
    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OperationType" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"profitType == %ld",self.operationVC.profitTypeControl.selectedSegmentIndex];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setPredicate:predicate];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:object];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object{
    
    OperationType* type = (OperationType*)object;
    cell.textLabel.text = type.name;
    if (arc4random() % 1000 > 500) {
        cell.imageView.image = [UIImage imageNamed:@"cup"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"transport-2"];
    }
}

- (void)createOperationTypeWithName:(NSString*)name profitType:(OperationTypeProfitType)profitType{
    
    
    [[DatabaseManager sharedManager] createOperationTypeWithName:name profitType:profitType];
    
}

#pragma mark - Actions

- (IBAction)actionAddButton:(UIBarButtonItem *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"New type"
                                                                   message:@"Please enter name of new type"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField* alertTextField = [[UITextField alloc] init];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        alertTextField = textField;
        
    }];
    
    UIAlertAction* actionDone = [UIAlertAction
                                 actionWithTitle:@"Done"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * _Nonnull action) {
                                
                                     [self createOperationTypeWithName:alertTextField.text
                                                            profitType:(OperationTypeProfitType)self.operationVC.profitTypeControl.selectedSegmentIndex];
                                   
                                 }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
    
    [alert addAction:actionDone];
    [alert addAction:actionCancel];

    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)actionCancelButton:(UIBarButtonItem *)sender {
     
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    self.operationVC.typeTextField.text = cell.textLabel.text;
    self.operationVC.selectedType = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (![self.operationVC.costTextField isFirstResponder]) {
        [self.operationVC.costTextField becomeFirstResponder];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
