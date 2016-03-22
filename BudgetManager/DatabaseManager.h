//
//  DatabaseManager.h
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Wallet.h"
#import "Operation.h"
#import "OperationType.h"
#import "Favourites.h"

@interface DatabaseManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DatabaseManager*)sharedManager;

- (Wallet*)createWalletWithName:(NSString*) name;
- (NSArray*)getWallets;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
