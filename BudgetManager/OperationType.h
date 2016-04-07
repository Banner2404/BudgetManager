//
//  OperationType.h
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    
    OperationTypeProfitTypeIncome,
    OperationTypeProfitTypeExpence
    
}OperationTypeProfitType;

@interface OperationType : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "OperationType+CoreDataProperties.h"
