//
//  HMRegion.m
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMRegion.h"

@implementation HMRegion
-(NSString *)title
{
    return self.name;
}

-(NSArray *)subtitles
{
    return self.subregions;
}
@end
