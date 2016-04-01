//
//  Wallet+CoreDataProperties.m
//  BudgetManager
//
//  Created by Соболь Евгений on 01.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wallet+CoreDataProperties.h"

@implementation Wallet (CoreDataProperties)

@dynamic bankMoney;
@dynamic cashMoney;
@dynamic isSecure;
@dynamic name;
@dynamic password;
@dynamic walletID;
@dynamic operations;

@end
