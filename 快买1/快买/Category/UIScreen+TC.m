//
//  UIScreen+WF.m
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-22.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "UIScreen+TC.h"

@implementation UIScreen (TC)

-(CGFloat)screenH{
    return [UIScreen mainScreen].bounds.size.height;
}

-(CGFloat)screenW{
    return [UIScreen mainScreen].bounds.size.width;
}

@end
