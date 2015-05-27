//
//  HMCenterLineLabel.m
//  BlackMember
//
//  Created by qianfeng on 15/5/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMCenterLineLabel.h"

@implementation HMCenterLineLabel

-(void)drawRect:(CGRect)rect
{
//    UILabel * view = [[UILabel alloc] init];
//    view.width = 30;
//    view.height = 5;
//    view.x = 0;
//    view.y = view.frame.origin.y/2;
    [super drawRect:rect];
    UIRectFill(CGRectMake(0, self.frame.size.height/2, self.frame.size.width, 1));
}

@end
