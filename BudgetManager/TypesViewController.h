//
//  TypesViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 25.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DatabaseViewController.h"

@class AddOperationViewController;

@interface TypesViewController : DatabaseViewController <NSFetchedResultsControllerDelegate>


@property (weak,nonatomic) AddOperationViewController* operationVC;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;
- (IBAction)actionAddButton:(UIBarButtonItem *)sender;


@end
