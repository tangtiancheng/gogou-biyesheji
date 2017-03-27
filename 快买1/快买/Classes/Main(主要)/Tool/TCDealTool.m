//
//  TCDealTool.m
//  快买
//
//  Created by 唐天成 on 16/1/18.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCDealTool.h"
#import "FMDB.h"
#import "TCDeal.h"
#import "TCShareMessage.h"
#import "MJExtension.h"


@interface TCDealTool()

@end
//数据库
static FMDatabase*  _db;

@implementation TCDealTool


+ (void)initialize
{
    if (self == [TCDealTool class]) {
        //获取沙盒路径
        NSString* path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* fileName=[path stringByAppendingPathComponent:@"t_deal.sqlite"];
        //1.创建数据库
        _db=[FMDatabase databaseWithPath:fileName];
        //2.打开数据库
        if([_db open]){
            //2.1创建收藏表
            //TCDeal->NSData
            //收藏表
            [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, deal BLOB NOT NULL, deal_id TEXT NOT NULL);"];
            //分享表
            [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_share_message(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, message BLOB NOT NULL);"];
            //最近浏览记录表
            [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_browser_deal(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,deal BLOB NOT NULL, deal_id TEXT NOT NULL)"];
        }
    }
}
/**
 *  返回最近浏览团购数据数组
 */
+ (NSArray *)browserDeals{
    FMResultSet* set=[_db executeQuery:@"SELECT * FROM t_browser_deal ORDER BY id DESC;"];
    NSMutableArray* deals=[NSMutableArray array];
    while ([set next]) {
        TCDeal* deal=[NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}

////总共了几个
//+ (int)collectDealsCount{
//     FMResultSet* set=[_db executeQuery:@"SELECT count(*) AS deal_count FROM t_collect_deal ;"];
//    [set next];
//    return [set intForColumn:@"deal_count"];
//}
/**
 *  添加一个浏览记录
 */
+ (void)addBrowserDeal:(TCDeal *)deal{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_browser_deal(deal,deal_id) VALUES(%@,%@);",data,deal.deal_id];
}

/**
 *  取消一个浏览记录
 */
+ (void)removeBrowserDeal:(TCDeal *)deal{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"DELETE FROM t_browser_deal WHERE deal_id=%@;",deal.deal_id];
}
/**
 *  团购是否曾经浏览过
 */
+ (BOOL)isBrowsered:(TCDeal *)deal{
    FMResultSet* set=[_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_browser_deal WHERE deal_id=%@;",deal.deal_id];
    [set next];
    return [set intForColumn:@"deal_count"]==1;
}




/**
 *  返回收藏团购数据
 */
+ (NSArray *)collectDeals{
    FMResultSet* set=[_db executeQuery:@"SELECT * FROM t_collect_deal ORDER BY id DESC;"];
    NSMutableArray* deals=[NSMutableArray array];
    while ([set next]) {
        TCDeal* deal=[NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}

//总共收藏了几个
+ (int)collectDealsCount{
    FMResultSet* set=[_db executeQuery:@"SELECT count(*) AS deal_count FROM t_collect_deal ;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(TCDeal *)deal{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal,deal_id) VALUES(%@,%@);",data,deal.deal_id];
}

/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(TCDeal *)deal{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id=%@;",deal.deal_id];
}
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(TCDeal *)deal{
    FMResultSet* set=[_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id=%@;",deal.deal_id];
    [set next];
    return [set intForColumn:@"deal_count"]==1;
}



/**
 *  返回分享的团购数据
 */
+(NSArray*)shareMessages{
    FMResultSet* set=[_db executeQuery:@"SELECT * FROM t_share_message ORDER BY id DESC"];
    NSMutableArray* messages=[NSMutableArray array];
    while ([set next]) {
        TCShareMessage* shareMessage=[NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"message"]];
//        NSLog(@"%@",shareMessage.textt);
        [messages addObject:shareMessage];
    }
    return messages;
}
/**
 *   添加一个分享
 */
+(void)addShareMessage:(TCShareMessage *)shareMessage{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:shareMessage];
    [_db executeUpdateWithFormat:@"INSERT INTO t_share_message(message) VALUES(%@);",data];
    
//    TCShareMessage* shareMessage1=[[TCShareMessage alloc]init];
//    shareMessage1.textt=@"第二个";
//    shareMessage1.image=shareMessage.image;
//    shareMessage1.date=shareMessage.date;
//    NSData* data1=[NSKeyedArchiver archivedDataWithRootObject:shareMessage1];
    
    
//    NSString* s=[shareMessage mj_JSONString];
//    NSString* s1=[shareMessage1 mj_JSONString];
//    UXThemeSourceUserInfo* info=[[UXThemeSourceUserInfo alloc]init];
//    TCjsonModel* jsonModel=[[TCjsonModel alloc]init];;
//    NSData* data11=[NSKeyedArchiver archivedDataWithRootObject:jsonModel];
//    NSString* sdata=[[NSString alloc] initWithData:data11 encoding:NSUTF8StringEncoding];
//    
//    NSArray* arr=@[sdata];
//    NSArray* a=@[@"1",@2];
//    [NSJSONSerialization dataWithJSONObject:a options:NSJSONWritingPrettyPrinted error:NULL];
//    NSData* dat=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:NULL];
//    
//    [_db executeUpdateWithFormat:@"INSERT INTO t_share_message(message) VALUES(%@);",dat];

}
@end
