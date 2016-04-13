//
//  FavoritesViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 13.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DatabaseViewController.h"

@class Wallet;

@interface FavouritesViewController : DatabaseViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Wallet* selectedWallet;

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;


@end
