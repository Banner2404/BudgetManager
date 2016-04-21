//
//  OperationType+CoreDataProperties.h
//  BudgetManager
//
//  Created by Соболь Евгений on 21.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OperationType.h"

NS_ASSUME_NONNULL_BEGIN

@class Operation;

@interface OperationType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *profitType;
@property (nullable, nonatomic, retain) NSNumber *count;
@property (nullable, nonatomic, retain) NSSet<Operation *> *operations;

@end

@interface OperationType (CoreDataGeneratedAccessors)

- (void)addOperationsObject:(Operation *)value;
- (void)removeOperationsObject:(Operation *)value;
- (void)addOperations:(NSSet<Operation *> *)values;
- (void)removeOperations:(NSSet<Operation *> *)values;

@end

NS_ASSUME_NONNULL_END
