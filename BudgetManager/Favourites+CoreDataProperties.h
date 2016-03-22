//
//  Favourites+CoreDataProperties.h
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Favourites.h"

NS_ASSUME_NONNULL_BEGIN

@interface Favourites (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *operations;

@end

@interface Favourites (CoreDataGeneratedAccessors)

- (void)addOperationsObject:(NSManagedObject *)value;
- (void)removeOperationsObject:(NSManagedObject *)value;
- (void)addOperations:(NSSet<NSManagedObject *> *)values;
- (void)removeOperations:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
