//
//  TCPaintPath.m
//  TCSmallPaintViewController
//
//  Created by 唐天成 on 16/1/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCPaintPath.h"

@implementation TCPaintPath

+(instancetype)paintPathWithLineWidth:(CGFloat)width color:(UIColor*)color startPoint:(CGPoint)point{
    TCPaintPath* path=[[self alloc]init];
    path.lineWidth=width;
    path.color=color;
    [path moveToPoint:point];
    return path;
}
@end
