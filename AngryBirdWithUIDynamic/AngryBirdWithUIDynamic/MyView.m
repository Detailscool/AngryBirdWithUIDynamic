//
//  MyView.m
//  AngryBirdWithUIDynamic
//
//  Created by Detailscool on 16/1/17.
//  Copyright © 2016年 Detailscool. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (void)drawRect:(CGRect)rect{

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 3);
    CGContextAddArc(ctx, 165, 265, 80, 0, M_PI*2, 1);

    CGContextStrokePath(ctx);
}


@end
