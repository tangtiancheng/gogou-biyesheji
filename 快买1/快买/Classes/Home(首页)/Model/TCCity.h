//
//  TCCity.h
//  快买
//
//  Created by 唐天成 on 16/1/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCity : NSObject
//城市名
@property (nonatomic, strong)NSString* name;
//pinYin
@property (nonatomic, strong)NSString* pinYin;
//pinYinHead
@property (nonatomic, strong)NSString* pinYinHead;
//区域
@property (nonatomic, strong)NSArray* regions;

@end
