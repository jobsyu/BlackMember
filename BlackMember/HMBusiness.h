//
//  HMBusiness.h
//  BlackMember
//
//  Created by qianfeng on 15/5/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMBusiness : NSObject
/** 店名 */
@property (nonatomic,copy) NSString *name;
/** 纬度 */
@property (nonatomic,assign) float latitude;
/** 经度 */
@property (nonatomic,assign) float longitude;
@end
