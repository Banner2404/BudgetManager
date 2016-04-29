//
//  StatisticsViewController.m
//  BudgetManager
//
//  Created by Соболь Евгений on 31.03.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "StatisticsViewController.h"
#import "DatabaseManager.h"
#import "DiagramView.h"

@interface StatisticsViewController () <UITableViewDelegate>

@property (strong,nonatomic) NSArray* data;
@property (strong,nonatomic) NSArray* colors;


@end

@implementation StatisticsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.intervalControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.data = [self getDataForWallet:self.selectedWallet];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor*)randomColor{
    
    CGFloat r = (CGFloat)(arc4random() % 256) / 255;
    CGFloat g = (CGFloat)(arc4random() % 256) / 255;
    CGFloat b = (CGFloat)(arc4random() % 256) / 255;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
    
}


- (NSManagedObjectContext*)managedObjectContext{
    
    if (_managedObjectContext) {
        return _managedObjectContext;
    }else{
        _managedObjectContext = [[DatabaseManager sharedManager] managedObjectContext];
        return _managedObjectContext;
    }
    
}

- (void)updateData{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.diagramView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.diagramView.transform = CGAffineTransformIdentity;
                                          }];
                         
                     }];
    
}

- (NSArray*)getDataForWallet:(Wallet*)wallet{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OperationType" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY operations.wallet.name == %@ AND count > 0",wallet.name];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray* result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    result = [result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        OperationType* object1 = (OperationType*)obj1;
        OperationType* object2 = (OperationType*)obj2;
        
        NSInteger total1 = [[DatabaseManager sharedManager] getTotalCostForOperationType:object1 andWallet:wallet];
        NSInteger total2 = [[DatabaseManager sharedManager] getTotalCostForOperationType:object2 andWallet:wallet];

        if (total1 > total2) {
            return NSOrderedAscending;
        }else if (total2 > total1){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
        
        
    }];
    
    NSMutableArray* diagramData = [NSMutableArray array];
    NSMutableArray* diagramColors = [NSMutableArray array];

    
    for (OperationType* operationType in result) {
        
        NSInteger cost = [[DatabaseManager sharedManager] getTotalCostForOperationType:operationType andWallet:wallet];
        
        [diagramData addObject:[NSNumber numberWithInteger:cost]];
        [diagramColors addObject:[self randomColor]];
        
    }
    
    NSLog(@"%@",diagramData);
 
    self.diagramView.data = diagramData;
    self.diagramView.colors = diagramColors;
    self.colors = diagramColors;

    
    return result;
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    OperationType *object = [self.data objectAtIndex:indexPath.row];
    [self configureCell:cell withObject:object atIndexPath:(NSIndexPath *)indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(OperationType *)operationType atIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView* imageView = [cell viewWithTag:1];
    
    if ([[[DatabaseManager sharedManager] defaultOperationTypes] objectForKey:operationType.name]) {
        imageView.image =
        [UIImage imageNamed:[[[DatabaseManager sharedManager] defaultOperationTypes] objectForKey:operationType.name]];
    }else
        imageView.image = [UIImage imageNamed:@"other"];

    UILabel* textLabel = [cell viewWithTag:2];
    textLabel.text = operationType.name;
    textLabel.textColor = [self.colors objectAtIndex:indexPath.row];
    
    UILabel* detailTextLabel = [cell viewWithTag:3];
    NSInteger cost = [[DatabaseManager sharedManager] getTotalCostForOperationType:operationType andWallet:self.selectedWallet];
    detailTextLabel.text = [NSString stringWithFormat:@"%ld",cost];
    
    
}

#pragma mark - Actions

- (IBAction)actionControl:(UISegmentedControl *)sender {
    
    [self updateData];
    
}

- (IBAction)actionRightSwipe:(UISwipeGestureRecognizer *)sender {
    
    if ([self.intervalControl selectedSegmentIndex] < 2) {
        
        NSInteger index = [self.intervalControl selectedSegmentIndex];
        index++;
        
        self.intervalControl.selectedSegmentIndex = index;
        
        [self updateData];
    }

    
}

- (IBAction)actionLeftSwipe:(UISwipeGestureRecognizer *)sender {
    
    if ([self.intervalControl selectedSegmentIndex] > 0) {
        
        NSInteger index = [self.intervalControl selectedSegmentIndex];
        index--;
        
        self.intervalControl.selectedSegmentIndex = index;
        
        [self updateData];
    }
    
}
@end
