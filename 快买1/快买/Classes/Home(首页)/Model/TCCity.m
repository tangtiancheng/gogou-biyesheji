//
//  TCCity.m
//  快买
//
//  Created by 唐天成 on 16/1/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCCity.h"
#import "MJExtension.h"
#import "TCRegion.h"
@implementation TCCity
+(NSDictionary *)mj_objectClassInArray{
    return @{@"regions":[TCRegion class]};
}
-(NSString*)description{
    return [NSString stringWithFormat:@"%@  %@  %@",self.name,self.pinYin,self.pinYinHead];
}
@end
