//
//  HMMetaTool.h
//  BlackMember
//
//  Created by qianfeng on 15/5/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMCategory,HMDeal;

@interface HMMetaTool : NSObject

/** 
  *  返回所有的的分类数据
  */
+(NSArray *)categories;
+(HMCategory *)categoryWithDeal:(HMDeal *)deal;
/**
 *  返回334个城市
 */
+(NSArray *)cities;

/**
  *  返回排序的各种情况
  */
+(NSArray *)sorts;

@end
