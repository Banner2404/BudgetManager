//
//  DatabaseManager.m
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

#pragma mark Static manager

+ (DatabaseManager*)sharedManager{
    
    static DatabaseManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DatabaseManager alloc] init];
        
    });
    
    return manager;
}

#pragma mark - Create

- (Wallet*)createWalletWithName:(NSString*) name cash:(NSInteger)cashMoney bank:(NSInteger)bankMoney security:(BOOL)isSecure password:(NSString *)password{
    
    Wallet* wallet = [NSEntityDescription insertNewObjectForEntityForName:@"Wallet"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    wallet.name = name;
    wallet.cashMoney = [NSNumber numberWithInteger:cashMoney];
    wallet.bankMoney = [NSNumber numberWithInteger:bankMoney];
    wallet.isSecure = [NSNumber numberWithBool:isSecure];
    wallet.password = password;

    
    return wallet;
    
}

- (OperationType*)createOperationTypeWithName:(NSString*)name{
    
    OperationType* type = [NSEntityDescription insertNewObjectForEntityForName:@"OperationType"
                                                        inManagedObjectContext:self.managedObjectContext];
    
    type.name = name;
    
    [self saveContext];
    return type;
    
}

#pragma mark - Get

- (NSArray*)getWallets{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Wallet"];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return results;
    
}

- (NSArray*)getOperationTypes{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"OperationType"];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return results;
    
}

#pragma mark - Add

- (Operation*)addOperationForWallet:(Wallet*)wallet type:(OperationType*) operationType cost:(NSInteger)cost moneyType:(MoneyType) moneyType profitType:(ProfitType)profitType date:(NSDate*)date{
    
    static NSInteger operationID = 0;
    
    Operation* operation = [NSEntityDescription insertNewObjectForEntityForName:@"Operation"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    operation.wallet = wallet;
    operation.type = operationType;
    operation.cost = [NSNumber numberWithInteger:cost];
    operation.moneyType = [NSNumber numberWithInteger:moneyType];
    operation.profitType = [NSNumber numberWithInteger:profitType];
    operation.date = date;
    operation.operationID = [NSNumber numberWithInteger:operationID ++];
    
    [self saveContext];
    
    return operation;
    
}

#pragma mark - Delete

- (void)deleteWallet:(Wallet *)wallet{
    
    
    [self.managedObjectContext deleteObject:wallet];
    
    [self saveContext];
    
}

#pragma mark - Show

- (void)showOperations{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Operation"];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (Operation* operation in results) {
        
        NSLog(@"Wallet: %@",operation.wallet.name);
        NSLog(@"Type: %@",operation.type.name);
        NSLog(@"Cost: %@",operation.cost);
        NSLog(@"Money type: %@",operation.moneyType);
        NSLog(@"Profit type: %@",operation.profitType);
        NSLog(@"Date: %@",operation.date);

        
    }
    
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "SobEv.BudgetManager" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BudgetManager" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BudgetManager.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
