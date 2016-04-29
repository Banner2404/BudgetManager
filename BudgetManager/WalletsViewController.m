//
//  WalletsViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "WalletsViewController.h"
#import "MainViewController.h"
#import "Wallet.h"

@interface WalletsViewController () <UITableViewDelegate>

@end

@implementation WalletsViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Wallet" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                               sectionNameKeyPath:nil
                                                                        cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _fetchedResultsController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != [tableView numberOfRowsInSection:0] - 1) {
        static NSString* identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            
        }
        
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [self configureCell:cell withObject:object];
        return cell;
    }else{
        NSString* identifier = @"addWallet";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        return cell;
    }
}


- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object{
    
    Wallet* wallet = (Wallet*)object;
    
    cell.textLabel.text = wallet.name;
    
}

- (void)validWalletAtIndexPath:(NSIndexPath *)indexPath{
    
    UINavigationController* nav = (UINavigationController*)self.presentingViewController;
    
    MainViewController* mainVC = (MainViewController*)nav.topViewController;
    
    Wallet* wallet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    mainVC.selectedWallet = wallet;
    [mainVC saveWallet];
    [mainVC refreshInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)showAlertWithTitle:(NSString*) title message:(NSString*) message actionName:(NSString*) actionName{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:actionName
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}



- (void)checkPasswordForWalletAtIndexPath:(NSIndexPath *)indexPath{
    
    Wallet* wallet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([wallet.isSecure boolValue]) {
        
        NSLog(@"Password: %@ %@",wallet.isSecure,wallet.password);
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Пароль"
                                                                       message:@"Введите пароль"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        __block UITextField* passwordTextField = nil;
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.secureTextEntry = YES;
            
            passwordTextField = textField;
            
        }];
        
        UIAlertAction* actionDone = [UIAlertAction
                                     actionWithTitle:@"Готово"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * _Nonnull action) {
                                         
                                         if ([passwordTextField.text isEqualToString:wallet.password]) {
                                             
                                             [self validWalletAtIndexPath:indexPath];
                                             
                                         }else{
                                             
                                             [self showAlertWithTitle:@"Ошибка"
                                                              message:@"Неверный пароль"
                                                           actionName:@"OK"];
                                             
                                         }
                                         
                                     }];
        
        UIAlertAction* actionCancel = [UIAlertAction
                                       actionWithTitle:@"Отмена"
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        
        [alert addAction:actionDone];
        [alert addAction:actionCancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        [self validWalletAtIndexPath:indexPath];
        
    }
}


#pragma mark - Actions

- (IBAction)actionCancelButton:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Segues

- (IBAction)prepareForUnwindToWallets:(UIStoryboardSegue*)segue{
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self checkPasswordForWalletAtIndexPath:indexPath];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
    
}


@end
