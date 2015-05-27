//
//  HMDealsTopMenu.h
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHomeTopItem : UIView

+(instancetype)item;

/** 
  * 设置监听器
  *
  *  prama  监听对象 target
  *  prama  监听方法 action
  */
- (void)addTarget:(id)target action:(SEL)action;

-(void)setTitle:(NSString *)title;
-(void)setSubtitle:(NSString *)subtitle;
-(void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
@end
