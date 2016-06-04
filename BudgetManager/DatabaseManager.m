//
//  DatabaseManager.m
//  BudgetManager
//
//  Created by Соболь Евгений on 22.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DatabaseManager.h"

@interface DatabaseManager ()

@property (strong,nonatomic) NSDictionary* incomeOperationsNames;
@property (strong,nonatomic) NSDictionary* expenceOperationsNames;


@end

@implementation DatabaseManager

- (instancetype)init
{
    self = [super init];
    if (self) {
                
        self.expenceOperationsNames = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"cinema",@"Кино",
                                       @"shop",@"Покупки",
                                       @"car",@"Машина",
                                       @"transport",@"Транспорт",
                                       @"restaurant",@"Ресторан",
                                       @"education",@"Образование",
                                       @"mobile",@"Мобильная связь",
                                       @"mail",@"Почтовые отправления",
                                       @"party",@"Развлечения",
                                       @"music",@"Концерты",
                                       @"home",@"Коммунальные",
                                       @"doctor",@"Лечение",
                                       @"travel",@"Путешествия",nil];
                
        self.incomeOperationsNames = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"salary",@"Зарплата",
                                      nil];
        
        self.defaultOperationTypes = [NSMutableDictionary dictionary];
        [self.defaultOperationTypes addEntriesFromDictionary:self.incomeOperationsNames];
        [self.defaultOperationTypes addEntriesFromDictionary:self.expenceOperationsNames];


    }
    return self;
}

#pragma mark Static manager

+ (DatabaseManager*)sharedManager{
    
    static DatabaseManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DatabaseManager alloc] init];
        
    });
    
    return manager;
}

#pragma mark - Create

- (Wallet*)createWalletWithName:(NSString*) name cash:(NSInteger)cashMoney bank:(NSInteger)bankMoney security:(BOOL)isSecure password:(NSString *)password{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger walletID = [[defaults valueForKey:@"walletID"] integerValue];
    
    Wallet* wallet = [NSEntityDescription insertNewObjectForEntityForName:@"Wallet"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    wallet.name = name;
    wallet.cashMoney = [NSNumber numberWithInteger:cashMoney];
    wallet.bankMoney = [NSNumber numberWithInteger:bankMoney];
    wallet.isSecure = [NSNumber numberWithBool:isSecure];
    wallet.password = password;
    wallet.walletID = [NSNumber numberWithInteger:walletID++];
    
    [defaults setInteger:walletID forKey:@"walletID"];
    
    [self saveContext];
    
    return wallet;
    
}

- (OperationType*)createOperationTypeWithName:(NSString*)name profitType:(OperationTypeProfitType)profitType{
    
    OperationType* type = [NSEntityDescription insertNewObjectForEntityForName:@"OperationType"
                                                        inManagedObjectContext:self.managedObjectContext];
    
    type.name = name;
    type.profitType = [NSNumber numberWithInteger:profitType];
    type.count = [NSNumber numberWithInteger:0];
    
    [self saveContext];
    return type;
    
}

#pragma mark - Get

- (NSArray*)getWallets{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Wallet"];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return results;
    
}


- (Wallet*)getWalletWithID:(NSInteger)walletID{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Wallet"];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"walletID == %ld",walletID];
    
    [request setPredicate:predicate];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return [results firstObject];
    
}

- (NSArray*)getOperationTypes{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"OperationType"];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return results;
    
}

- (OperationType*)getOperationTypeWithName:(NSString*) name andProfitType:(OperationTypeProfitType) profitType{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"OperationType"];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name == %@ AND profitType == %ld",name,profitType];
    
    [request setPredicate:predicate];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    if ([results count]) {
        return [results objectAtIndex:0];
    }else{
        return nil;
    }
    
}

- (NSInteger)getTotalCostForOperationType:(OperationType*)operationType andWallet:(Wallet*)wallet fromDate:(NSDate*)fromDate toDate:(NSDate*)toDate{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Operation"];
    
    NSPredicate* predicateWallet = [NSPredicate predicateWithFormat:@"wallet.name == %@",wallet.name];
    NSPredicate* predicateType = [NSPredicate predicateWithFormat:@"type.name == %@",operationType.name];
    NSPredicate* predicateDate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@",fromDate,toDate];
    
    NSCompoundPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateWallet,predicateType,predicateDate]];
    
    [request setPredicate:predicate];
    
    NSArray* array = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    NSInteger totalCost = 0;
    for (Operation* operation in array) {
        
        NSInteger cost = [operation.cost integerValue];
        totalCost += cost;
    }

    return totalCost;
}

#pragma mark - Add

- (void)addOperationInFavourites:(Operation*)operation{
    
    Favourites* favourites = [Favourites sharedFavourites];
    
    [favourites addOperationsObject:operation];
    
    [self saveContext];

    
}
- (Operation*)addOperationForWallet:(Wallet*)wallet type:(OperationType*) operationType cost:(NSInteger)cost moneyType:(OperationMoneyType) moneyType profitType:(OperationProfitType)profitType date:(NSDate*)date{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSInteger operationID = [[defaults valueForKey:@"operationID"] integerValue];
    
    Operation* operation = [NSEntityDescription insertNewObjectForEntityForName:@"Operation"
                                                         inManagedObjectContext:self.managedObjectContext];
    operation.wallet = wallet;
    operation.type = operationType;
    operation.cost = [NSNumber numberWithInteger:cost];
    operation.moneyType = [NSNumber numberWithInteger:moneyType];
    operation.profitType = [NSNumber numberWithInteger:profitType];
    operation.date = date;
    operation.operationID = [NSNumber numberWithInteger:operationID ++];
    
    NSInteger count = [operationType.count integerValue];
    operationType.count = [NSNumber numberWithInteger:count+1];

    
    NSInteger money;
    
    if (moneyType == OperationMoneyTypeCash) {
        
        money = [wallet.cashMoney integerValue];
        
        if (profitType == OperationProfitTypeIncome) {
            
            wallet.cashMoney = [NSNumber numberWithInteger:money + cost];
            
        }else{
            
            wallet.cashMoney = [NSNumber numberWithInteger:money - cost];
         
        }
        
    }else{
        
        money = [wallet.bankMoney integerValue];
        
        if (profitType == OperationProfitTypeIncome) {
            
            wallet.bankMoney = [NSNumber numberWithInteger:money + cost];
            
        }else{
            
            wallet.bankMoney = [NSNumber numberWithInteger:money - cost];
            
        }

        
    }
    
    [defaults setInteger:operationID forKey:@"operationID"];
    [self saveContext];
    
    return operation;
    
}

#pragma mark - Delete

- (void)deleteWallet:(Wallet *)wallet{
    
    
    [self.managedObjectContext deleteObject:wallet];
    
    [self saveContext];
    
}

- (void)deleteOperation:(Operation*)operation{
    
    [self.managedObjectContext deleteObject:operation];
    
    [self saveContext];
    
}

#pragma mark - Show

- (void)showOperations{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Operation"];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (Operation* operation in results) {
        
        NSLog(@"Wallet: %@",operation.wallet.name);
        NSLog(@"Type: %@",operation.type.name);
        NSLog(@"Cost: %@",operation.cost);
        NSLog(@"Money type: %@",operation.moneyType);
        NSLog(@"Profit type: %@",operation.profitType);
        NSLog(@"Date: %@",operation.date);

        
    }
    
}

- (void)checkDefaultOperationTypes{
    
    for (NSString* name in self.incomeOperationsNames.allKeys) {
        
        if (![self getOperationTypeWithName:name andProfitType:OperationTypeProfitTypeIncome]) {
            
            [self createOperationTypeWithName:name profitType:OperationTypeProfitTypeIncome];
            
        }
        
    }
    for (NSString* name in self.expenceOperationsNames.allKeys) {
        
        if (![self getOperationTypeWithName:name andProfitType:OperationTypeProfitTypeExpence]) {
            
            [self createOperationTypeWithName:name profitType:OperationTypeProfitTypeExpence];
            
        }
        
    }

    
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "SobEv.BudgetManager" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BudgetManager" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BudgetManager.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        
        self.mustLoadDefaultTypes = YES;
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
