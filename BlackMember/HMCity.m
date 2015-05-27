//
//  HMCity.m
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMCity.h"
#import "HMRegion.h"

@implementation HMCity

-(NSDictionary *)objectClassInArray
{
    return @{@"regions" : [HMRegion class]};
}

@end
