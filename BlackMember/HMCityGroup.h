//
//  HMCItyGroup.h
//  BlackMember
//
//  Created by qianfeng on 15/5/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCityGroup : NSObject

/** 这组的标题 */
@property (nonatomic,copy) NSString *title;
/** 这组的所有城市 */
@property (nonatomic,strong) NSArray *cities;

@end
