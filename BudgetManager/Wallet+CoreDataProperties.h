//
//  Wallet+CoreDataProperties.h
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Wallet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *bankMoney;
@property (nullable, nonatomic, retain) NSNumber *cashMoney;
@property (nullable, nonatomic, retain) NSNumber *isSecure;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *operations;

@end

@interface Wallet (CoreDataGeneratedAccessors)

- (void)addOperationsObject:(NSManagedObject *)value;
- (void)removeOperationsObject:(NSManagedObject *)value;
- (void)addOperations:(NSSet<NSManagedObject *> *)values;
- (void)removeOperations:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
