//
//  DiagramView.h
//  BudgetManager
//
//  Created by Соболь Евгений on 29.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiagramView : UIView

@property (strong,nonatomic) NSArray* data;
@property (strong,nonatomic) NSMutableArray* colors;
@property (assign,nonatomic) CGFloat maxAngle;
@property (assign,nonatomic) NSInteger selectedSegmentIndex;

@end
