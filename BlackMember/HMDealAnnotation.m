//
//  HMDealAnnotation.m
//  BlackMember
//
//  Created by qianfeng on 15/5/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMDealAnnotation.h"

@implementation HMDealAnnotation
-(BOOL)isEqual:(HMDealAnnotation *)other
{
    return [self.title isEqual:other.title];
}

@end
