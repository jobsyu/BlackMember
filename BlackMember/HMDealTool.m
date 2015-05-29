//
//  HMDealTool.m
//  BlackMember
//
//  Created by qianfeng on 15/5/27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMDealTool.h"
#import "FMDB.h"
#import "HMDeal.h"

@implementation HMDealTool

static FMDatabase *_db;

+ (void)initialize
{
    //1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if(!_db.open) return;
    
    //创建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY,deal blob NOT NULL,deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY,deal blob NOT NULL,deal_id text NOT NULL);"];
}

#pragma mark - collect deal
+(NSArray *)collectDeals:(int)page
{
    int size = 20;
    int pos = (page -1) *size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;",pos,size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        HMDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}

+ (void)addCollectDeal:(HMDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal,deal_id) VALUES(%@, %@);",data, deal.deal_id];
}

+(void)removeCollectDeal:(HMDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;",deal.deal_id];
}

+(BOOL)isCollected:(HMDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;",deal.deal_id];
    
    [set next];
    
    return [set intForColumn:@"deal_count"] == 1;
}

+(int)collectDealsCount
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}

#pragma mark - recent deal
+(NSArray *)recentDeals:(int)page
{
    int size = 20;
    int pos = (page -1) *size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_recent_deal ORDER BY id DESC LIMIT %d,%d;",pos,size];
    NSMutableArray *deals = [NSMutableArray array];
    while ([set next]) {
        HMDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}

+(void)addRecentDeal:(HMDeal *)deal
{
    NSData  *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_recent_deal(deal,deal_id) VALUES(%@,%@);",data,deal.deal_id];
}

+(void)removeRecentDeal:(HMDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_recent_deal WHERE deal_id = %@;",deal.deal_id];
}

+(BOOL)isRecented:(HMDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_recent_deal WHERE deal_id =%@;",deal.deal_id];
    [set next];
    return [set intForColumn:@"deal_count"] == 1;
}

+(int)recentDealsCount
{
    FMResultSet *set= [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_recent_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}
@end
