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
    
    rectSize -= lineWidth;
    
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
    
    for (int i = 0; i < [self.data count]; i++){
        
        CGFloat part = [[self.data objectAtIndex:i] doubleValue] / totalValue;
        
        CGFloat newAngle = angle + (part * 2 * M_PI);
        
        CGContextAddArc(context,
                        CGRectGetMinX(diagramRect), CGRectGetMinY(diagramRect), CGRectGetWidth(diagramRect) / 2,
                        angle, newAngle,
                        0);
        
        angle = newAngle;
        
        CGContextSetLineWidth(context, lineWidth);
        
        CGContextSetStrokeColorWithColor(context, [[self.colors objectAtIndex:i] CGColor]);
        
        CGContextStrokePath(context);
        
    }


}


@end
