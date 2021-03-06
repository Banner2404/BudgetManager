//
//  Operation.h
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Favourites, OperationType, Wallet;

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    OperationMoneyTypeCash,
    OperationMoneyTypeBank
}OperationMoneyType;

typedef enum{
    
    OperationProfitTypeIncome,
    OperationProfitTypeExpence
    
}OperationProfitType;

@interface Operation : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Operation+CoreDataProperties.h"
