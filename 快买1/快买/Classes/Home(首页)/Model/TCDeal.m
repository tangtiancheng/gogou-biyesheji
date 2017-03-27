//
//  TCDeal.m
//  快买
//
//  Created by 唐天成 on 16/1/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCDeal.h"
#import "MJExtension.h"
#import "TCBusiness.h"
@implementation TCDeal
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"desc":@"description"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"businesses" : [TCBusiness class]};
}

//重写equal方法
- (BOOL)isEqual:(TCDeal*)other
{
    return [self.deal_id isEqualToString:other.deal_id];
}
//用了MJExtension
//写上下面这句后直接就能自定义对象归档解档了,也就是可以变成2进制了
MJCodingImplementation
@end
