//
//  HMDealCell.h
//  BlackMember
//
//  Created by qianfeng on 15/5/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class HMDeal ,HMDealCell;

@protocol HMDealCellDelegate <NSObject>

@optional
-(void)dealCellCheckingStateDidChange:(HMDealCell *)cell;

@end

@interface HMDealCell : UICollectionViewCell
@property (nonatomic,strong) HMDeal *deal;
@property (nonatomic,weak) id<HMDealCellDelegate> delegate;
@end
