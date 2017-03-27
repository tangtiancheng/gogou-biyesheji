//
//  NSDate+NJ.h
//  传智WB
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NJ)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

@end
