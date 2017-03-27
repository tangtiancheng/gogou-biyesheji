//
//  TCCenterLineLabel.m
//  快买
//
//  Created by 唐天成 on 16/1/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCCenterLineLabel.h"

@implementation TCCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //在中间划一条线
    UIRectFill(CGRectMake(0, rect.size.height * 0.5, rect.size.width, 1));
    
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画线
    // 设置起点
    //    CGContextMoveToPoint(ctx, 0, rect.size.height * 0.5);
    //    // 连线到另一个点
    //    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height * 0.5);
    //    // 渲染
    //    CGContextStrokePath(ctx);
}


@end
