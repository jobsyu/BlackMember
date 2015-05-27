//
//  HMSort.h
//  BlackMember
//
//  Created by qianfeng on 15/5/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSort : NSObject
/** 排序名称 */
@property (nonatomic,copy) NSString *label;
/** 排序的值(将来发给服务器) */
@property (nonatomic,assign) int value;

@end
