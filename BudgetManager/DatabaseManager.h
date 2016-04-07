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

- (void)deleteWallet:(Wallet*)wallet;
- (Wallet*)createWalletWithName:(NSString*) name cash:(NSInteger) cashMoney bank:(NSInteger)bankMoney security:(BOOL) isSecure password:(NSString*) password;
- (OperationType*)createOperationTypeWithName:(NSString*)name profitType:(OperationTypeProfitType)profitType;
- (Operation*)addOperationForWallet:(Wallet*)wallet type:(OperationType*) operationType cost:(NSInteger)cost moneyType:(OperationMoneyType) moneyType profitType:(OperationProfitType)profitType date:(NSDate*)date;
- (NSArray*)getWallets;
- (Wallet*)getWalletWithID:(NSInteger)walletID;
- (NSArray*)getOperationTypes;
- (void)showOperations;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
