//
//  Favourites.m
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "Favourites.h"
#import "DatabaseManager.h"

@implementation Favourites

+ (Favourites*)sharedFavourites{

    static Favourites* favourites = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        favourites = [NSEntityDescription insertNewObjectForEntityForName:@"Favourites" inManagedObjectContext:[[DatabaseManager sharedManager] managedObjectContext]];
    });
    
    return favourites;
    
}

@end
