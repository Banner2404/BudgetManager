//
//  StatisticsViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 31.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DatabaseViewController.h"

@class Wallet;
@class DiagramView;

@interface StatisticsViewController : UIViewController
@property (weak, nonatomic) IBOutlet DiagramView *diagramView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UISegmentedControl *intervalControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Wallet* selectedWallet;
- (IBAction)actionControl:(UISegmentedControl *)sender;
- (IBAction)actionRightSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)actionLeftSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)actionProfitChange:(UIButton *)sender;

@end
