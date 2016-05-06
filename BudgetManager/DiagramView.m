//
//  DiagramView.m
//  BudgetManager
//
//  Created by Соболь Евгений on 29.04.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

#import "DiagramView.h"

@implementation DiagramView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {

    NSInteger rectSize = MIN(rect.size.height, rect.size.width);
    
    NSInteger lineWidth = rectSize / 3;
    
    rectSize -= lineWidth + 25;
    
    NSInteger rectOriginX = CGRectGetMidX(rect);
    NSInteger rectOriginY = CGRectGetMidY(rect);
    
    CGRect diagramRect = CGRectMake(rectOriginX, rectOriginY, rectSize, rectSize);
        
    NSInteger totalValue = 0;
    
    for (NSNumber* number in self.data) {
        totalValue += [number integerValue];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat startAngle = - M_PI_2;
    
    CGFloat angle = 0 + startAngle;
    
    if ([self.data count] == 0){
        
        CGContextAddArc(context,
                        CGRectGetMinX(diagramRect), CGRectGetMinY(diagramRect), CGRectGetWidth(diagramRect) / 2,
                        0, 2 * M_PI,
                        0);
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:53.f/256 green:147.f/256 blue:127.f/256 alpha:0.1]CGColor]);

        CGContextStrokePath(context);
    }
    
    for (int i = 0; i < [self.data count]; i++){
        
        CGFloat part = [[self.data objectAtIndex:i] doubleValue] / totalValue;
        
        CGFloat newAngle = angle + (part * 2 * M_PI);
        
        CGFloat radius = CGRectGetWidth(diagramRect) / 2;
        
        
        if (i == self.selectedSegmentIndex) {
            radius += 5;
        }
        
        CGContextAddArc(context,
                        CGRectGetMinX(diagramRect), CGRectGetMinY(diagramRect), radius,
                        angle, newAngle,
                        0);
        
        angle = newAngle;
        
        CGContextSetLineWidth(context, lineWidth);
        
        if (i == self.selectedSegmentIndex) {
            CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:48.f/256 green:97.f/256 blue:117.f/256 alpha:1] CGColor]);
        }else{
            CGContextSetStrokeColorWithColor(context, [[self.colors objectAtIndex:i] CGColor]);
        }
        
        
        CGContextStrokePath(context);
        
    }


}


@end
