//
//  WalletsViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DatabaseViewController.h"

@interface WalletsViewController : DatabaseViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;
- (IBAction)actionCancelButton:(UIBarButtonItem *)sender;

@end
