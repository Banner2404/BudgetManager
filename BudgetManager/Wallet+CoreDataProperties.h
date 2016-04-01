//
//  Wallet+CoreDataProperties.h
//  BudgetManager
//
//  Created by Соболь Евгений on 01.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wallet.h"

NS_ASSUME_NONNULL_BEGIN

@class Operation;

@interface Wallet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *bankMoney;
@property (nullable, nonatomic, retain) NSNumber *cashMoney;
@property (nullable, nonatomic, retain) NSNumber *isSecure;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSNumber *walletID;
@property (nullable, nonatomic, retain) NSSet<Operation *> *operations;

@end

@interface Wallet (CoreDataGeneratedAccessors)

- (void)addOperationsObject:(Operation *)value;
- (void)removeOperationsObject:(Operation *)value;
- (void)addOperations:(NSSet<Operation *> *)values;
- (void)removeOperations:(NSSet<Operation *> *)values;

@end

NS_ASSUME_NONNULL_END
