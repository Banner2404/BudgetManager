//
//  AppDelegate.m
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseManager.h"

@interface AppDelegate ()

@property (strong,nonatomic) DatabaseManager* databaseManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.databaseManager = [DatabaseManager sharedManager];
    
//    Wallet* wallet1 = [self.databaseManager createWalletWithName:@"Banner1"];
//    Wallet* wallet2 = [self.databaseManager createWalletWithName:@"Banner2"];
//    Wallet* wallet3 = [self.databaseManager createWalletWithName:@"Banner3"];
//
//    
//    [self.databaseManager saveContext];
    
//    OperationType* type1 = [self.databaseManager createOperationTypeWithName:@"Type1"];
//    OperationType* type2 = [self.databaseManager createOperationTypeWithName:@"Type2"];
//    OperationType* type3 = [self.databaseManager createOperationTypeWithName:@"Type3"];
//    
//    [self.databaseManager saveContext];

    //Wallet* wallet = [[self.databaseManager getWallets] firstObject];
    
    //NSLog(@"%@",wallet.name);
    
    NSLog(@"Wallets: %ld",[[self.databaseManager getWallets] count]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[DatabaseManager sharedManager] saveContext];
}
@end
