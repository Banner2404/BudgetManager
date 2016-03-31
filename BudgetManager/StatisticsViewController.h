//
//  StatisticsViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 31.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DatabaseViewController.h"

@class Wallet;

@interface StatisticsViewController : DatabaseViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Wallet* selectedWallet;

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;

@end
