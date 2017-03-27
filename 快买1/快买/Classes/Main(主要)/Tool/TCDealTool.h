//
//  TCDealTool.h
//  快买
//
//  Created by 唐天成 on 16/1/18.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class TCDeal;
@class TCShareMessage;



@interface TCDealTool : NSObject

/**
 *  返回收藏团购数据
 */
+ (NSArray *)collectDeals;
+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(TCDeal *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(TCDeal *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(TCDeal *)deal;


/**
 *  返回最近浏览团购数据数组
 */
+ (NSArray *)browserDeals;
/**
 *  添加一个浏览记录
 */
+ (void)addBrowserDeal:(TCDeal *)deal;
/**
 *  取消一个浏览记录
 */
+ (void)removeBrowserDeal:(TCDeal *)deal;
/**
 *  团购是否曾经浏览过
 */
+ (BOOL)isBrowsered:(TCDeal *)deal;


/**
 *  返回分享的团购数据
 */
+(NSArray*)shareMessages;
/**
 *   添加一个分享
 */
+(void)addShareMessage:(TCShareMessage *)shareMessage;
@end
