//
//  HMCategoryViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMCategoryViewController.h"
#import "HMHomeDropdown.h"
#import "HMMetaTool.h"
#import "HMCategory.h"
#import "HMConst.h"

@interface HMCategoryViewController () <HMHomeDropdownDataSource,HMHomeDropdownDelegate>

@end

@implementation HMCategoryViewController

-(void)loadView
{
    HMHomeDropdown *dropdown = [HMHomeDropdown dropItem];
    dropdown.datasource = self;
    dropdown.delegate = self;
    self.view = dropdown;
    
    //设置控制器view在popover中的尺寸
    self.preferredContentSize = dropdown.size;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - HMHomeDropdownDataSource
-(NSInteger)numberOfRowsInMainTable:(HMHomeDropdown *)homeDropdown
{
    return [HMMetaTool categories].count;
}

-(NSString *)homeDropdown:(HMHomeDropdown *)homeDropdown iconForRowInMainTable:(NSInteger)row
{
    HMCategory *category = [HMMetaTool categories][row];
    return category.small_icon;
}

-(NSString *)homeDropdown:(HMHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row
{
    HMCategory *category = [HMMetaTool categories][row];
    return category.small_highlighted_icon;
}

-(NSString *)homeDropdown:(HMHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row
{
    HMCategory *category = [HMMetaTool categories][row];
    return category.name;
}

-(NSArray *)homeDropdown:(HMHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row
{
    HMCategory *category = [HMMetaTool categories][row];
    return category.subcategories;
}


#pragma mark - HMHomeDropdownDelegate
-(void)homeDropdown:(HMHomeDropdown *)homeDropdown didSelectRowInMainTable:(int)mainRow
{
    HMCategory *category =[HMMetaTool categories][mainRow];
    if(category.subcategories.count == 0)
    {
      [HMNotificationCenter postNotificationName:HMCategoryDidChangeNotification object:nil userInfo:@{HMSelectCategory : category}];
    }
}

-(void)homeDropdown:(HMHomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subRow InMainTable:(int)mainRow
{
    HMCategory *category = [HMMetaTool categories][mainRow];
    
    [HMNotificationCenter postNotificationName:HMCategoryDidChangeNotification object:nil userInfo:@{HMSelectCategory : category,HMSelectSubcategoryName :category.subcategories[subRow]}];
}
@end
