//
//  HMDealListViewController.h
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDealsViewController : UICollectionViewController

/** 设置请求参数，让子类去实现 */
-(void)setParameter:(NSMutableDictionary *)params;
@end
