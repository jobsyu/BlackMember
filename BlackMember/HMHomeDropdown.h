//
//  HMDropdownMenuItem.h
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMHomeDropdown;

//@protocol HMDropdownMenuItem <NSObject>
//@required
///** 标题 */
//-(NSString *)title;
///** 子标题数据 */
//-(NSArray *)subtitles;
//
//@optional
///**  图标 */
//- (NSString *)image;
///** 选中的图标 */
//- (NSString *)highlightedImage;
//@end



/** HMHomeDropdownDataSource */
@protocol HMHomeDropdownDataSource <NSObject>

/** 
  * 左边表格一共有多少行
  */
-(NSInteger)numberOfRowsInMainTable:(HMHomeDropdown *)homeDropdown;

/**
  * 左边表格每一行的标题
  *  @param row   行号
  */
-(NSString *)homeDropdown:(HMHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row;

/**
  *  左边表格每一行的子数据
  *  @param row   行号
  */
-(NSArray *)homeDropdown:(HMHomeDropdown *)homeDropdown  subdataForRowInMainTable:(NSInteger)row;


@optional
/** 
  * 左边表格每一行的图标
  * @param row 行号
  */
-(NSString *)homeDropdown:(HMHomeDropdown *)homeDropdown iconForRowInMainTable:(NSInteger)row;

/**
 * 左边表格每一行的选中图标
 * @param row  行号
 */
-(NSString *)homeDropdown:(HMHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row;


@end

/** HMHomeDropdownDelegate **/
@protocol HMHomeDropdownDelegate <NSObject>

@optional
- (void)homeDropdown:(HMHomeDropdown *)homeDropdown didSelectRowInMainTable:(int)mainRow;
- (void)homeDropdown:(HMHomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subRow InMainTable:(int)mainRow;
@end


@interface HMHomeDropdown : UIView
+ (instancetype)dropItem;
//@property (nonatomic,strong) NSArray *items;
@property (nonatomic,weak) id<HMHomeDropdownDataSource> datasource;
@property (nonatomic,weak) id<HMHomeDropdownDelegate> delegate;

@end