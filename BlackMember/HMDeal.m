//
//  HMDeal.m
//  BlackMember
//
//  Created by qianfeng on 15/5/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMDeal.h"
#import "MJExtension.h"

@implementation HMDeal

- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

-(BOOL)isEqual:(HMDeal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}

MJCodingImplementation
@end
