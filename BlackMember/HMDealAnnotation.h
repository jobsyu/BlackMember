//
//  HMDealAnnotation.h
//  BlackMember
//
//  Created by qianfeng on 15/5/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HMDealAnnotation : NSObject
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
/** 图片名 */
@property (nonatomic,copy) NSString *icon;
@end
