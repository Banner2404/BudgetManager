//
//  FilterViewController.h
//  BudgetManager
//
//  Created by Соболь Евгений on 01.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    
    FilterSortTypeName,
    FilterSortTypeCost,
    FilterSortTypeDate
    
}FilterSortType;

typedef enum{
    
    FilterMoneyTypeNone,
    FilterMoneyTypeCash,
    FilterMoneyTypeBank
    
}FilterMoneyType;

typedef enum{
    
    FilterProfitTypeNone,
    FilterProfitTypeIncome,
    FilterProfitTypeExpence
    
}FilterProfitType;

typedef enum{
    
    FilterDateTypeNone,
    FilterDateTypeWeek,
    FilterDateTypeMonth
    
}FilterDateType;

@interface FilterViewController : UITableViewController

@property (strong, nonatomic) IBOutletCollection(UISegmentedControl) NSArray *sortTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moneyTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *profitTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateControl;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *costTextField;
@property (assign, nonatomic) NSInteger minCost;
@property (assign, nonatomic) NSInteger maxCost;



@end
