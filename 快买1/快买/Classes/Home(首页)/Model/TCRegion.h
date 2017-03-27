//
//  TCRegion.h
//  快买
//
//  Created by 唐天成 on 16/1/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCRegion : NSObject
//区域名
@property (nonatomic, strong)NSString* name;
//街道名数组
@property (nonatomic, strong)NSArray* subregions;

@end
