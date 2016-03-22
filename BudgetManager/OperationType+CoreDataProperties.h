//
//  OperationType+CoreDataProperties.h
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OperationType.h"

NS_ASSUME_NONNULL_BEGIN

@interface OperationType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *operations;

@end

@interface OperationType (CoreDataGeneratedAccessors)

- (void)addOperationsObject:(NSManagedObject *)value;
- (void)removeOperationsObject:(NSManagedObject *)value;
- (void)addOperations:(NSSet<NSManagedObject *> *)values;
- (void)removeOperations:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
