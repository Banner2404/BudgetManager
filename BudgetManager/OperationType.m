//
//  OperationType.m
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "OperationType.h"

@implementation OperationType

- (NSComparisonResult)compare:(id)other
{
    
    OperationType* otherType = (OperationType*)other;
    return [self.name compare:otherType.name];
}

@end
