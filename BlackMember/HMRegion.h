//
//  HMRegion.h
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRegion : NSObject
/** 区域名称 */
@property (copy,nonatomic) NSString *name;
/** 子区域 */
@property (strong,nonatomic) NSArray *subregions;
@end
