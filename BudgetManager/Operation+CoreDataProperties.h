//
//  Operation+CoreDataProperties.h
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Operation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Operation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cost;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *moneyType;
@property (nullable, nonatomic, retain) NSNumber *operationID;
@property (nullable, nonatomic, retain) NSNumber *profitType;
@property (nullable, nonatomic, retain) OperationType *type;
@property (nullable, nonatomic, retain) Wallet *wallet;
@property (nullable, nonatomic, retain) Favourites *favourite;

@end

NS_ASSUME_NONNULL_END
