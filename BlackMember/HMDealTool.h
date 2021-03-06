//
//  HMDealTool.h
//  BlackMember
//
//  Created by qianfeng on 15/5/27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMDeal;

@interface HMDealTool : NSObject

#pragma mark -collect
/** 
  *  返回第page页的收藏团购数据：page从1开始
  */
+ (NSArray *)collectDeals:(int)page;
+ (int)collectDealsCount;

/** 
  * 收藏一个团购
  */
+ (void)addCollectDeal:(HMDeal *)deal;
/**
 * 取消收藏一个团购
 */
+ (void)removeCollectDeal:(HMDeal *)deal;
/**
  * 团购是否收藏
  */
+ (BOOL)isCollected:(HMDeal *)deal;


#pragma mark -recent
/**
 *  返回第page页的收藏团购数据：page从1开始
 */
+ (NSArray *)recentDeals:(int)page;
+ (int)recentDealsCount;

/**
 * 收藏一个团购
 */
+ (void)addRecentDeal:(HMDeal *)deal;
/**
 * 取消收藏一个团购
 */
+ (void)removeRecentDeal:(HMDeal *)deal;
/**
 * 团购是否收藏
 */
+ (BOOL)isRecented:(HMDeal *)deal;
@end
