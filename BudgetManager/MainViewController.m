//
//  MainViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 23.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "AddOperationViewController.h"
#import "StatisticsViewController.h"
#import "FavouritesViewController.h"
#import "DatabaseManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger selectedWalletID = [defaults integerForKey:@"selectedWalletID"];
    
    NSLog(@"load %ld",selectedWalletID);
    
    self.selectedWallet = [[DatabaseManager sharedManager] getWalletWithID:selectedWalletID];
    
    [self refreshInfo];
    [self setDate];
    
}

- (void)saveWallet{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:[self.selectedWallet.walletID integerValue] forKey:@"selectedWalletID"];
    NSLog(@"save %ld",[self.selectedWallet.walletID integerValue]);
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self refreshInfo];
    [self setDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDate{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"d MMMM"];
    
    NSString* date = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    [self.dateButton setTitle:date forState:UIControlStateNormal];
    
    NSLog(@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]]);
    
}


- (void)refreshInfo{
    
    if (self.selectedWallet) {
        
        [self.walletButton setTitle:self.selectedWallet.name forState:UIControlStateNormal];
        self.cashMoneyLabel.text = [NSString stringWithFormat:@"%@ $",self.selectedWallet.cashMoney];
        if ([self.selectedWallet.cashMoney integerValue] < 0) {
            self.cashMoneyLabel.textColor = [UIColor redColor];
        }else{
            self.cashMoneyLabel.textColor = [UIColor whiteColor];
        }
        self.bankMoneyLabel.text = [NSString stringWithFormat:@"%@ $",self.selectedWallet.bankMoney];
        if ([self.selectedWallet.bankMoney integerValue] < 0) {
            self.bankMoneyLabel.textColor = [UIColor redColor];
        }else{
            self.bankMoneyLabel.textColor = [UIColor whiteColor];
        }
        
        
    }else{
        
        [self.walletButton setTitle:@"No wallet" forState:UIControlStateNormal];
        self.cashMoneyLabel.text = @"0 $";
        self.cashMoneyLabel.textColor = [UIColor blackColor];
        self.bankMoneyLabel.text = @"0 $";
        self.bankMoneyLabel.textColor = [UIColor blackColor];

    }

    
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier  isEqualToString: @"statisticsSegue"]) {
        
        StatisticsViewController* vc = segue.destinationViewController;
        vc.selectedWallet = self.selectedWallet;
        
    }else if ([segue.identifier  isEqualToString: @"favouritesSegue"]){
        
        FavouritesViewController* vc = segue.destinationViewController;
        vc.selectedWallet = self.selectedWallet;
        
    }else if ([segue.identifier  isEqualToString: @"settingsSegue"]){
        
        SettingsViewController* vc = segue.destinationViewController;
        vc.selectedWallet = self.selectedWallet;
        
    }else if ([segue.identifier  isEqualToString: @"addOperationSegue"]){
        
        AddOperationViewController* vc = segue.destinationViewController;
        vc.selectedWallet = self.selectedWallet;
        
    }
}
@end
