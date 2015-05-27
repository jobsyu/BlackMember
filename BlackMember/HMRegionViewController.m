//
//  HMRegionViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMRegionViewController.h"
#import "HMHomeDropdown.h"
#import "HMRegion.h"
#import "HMCityViewController.h"
#import "HMNavigationController.h"
#import "HMConst.h"

@interface HMRegionViewController () <HMHomeDropdownDataSource,HMHomeDropdownDelegate>

-(IBAction)changeCity;

@end

@implementation HMRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建下拉菜单
    UIView *title = [self.view.subviews firstObject];
    HMHomeDropdown *dropdown = [HMHomeDropdown dropItem];
    dropdown.datasource =self;
    dropdown.delegate = self;
    dropdown.y = title.height;
    [self.view addSubview:dropdown];
    
    //设置控制器在popover中的尺寸
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));

}

/**
 * 切换城市
 */
- (IBAction)changeCity
{
    [self.popover dismissPopoverAnimated:YES];
    
    HMCityViewController *city = [[HMCityViewController alloc] init];
    
    HMNavigationController *nav =[[HMNavigationController alloc] initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    //[self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfRowsInMainTable:(HMHomeDropdown *)homeDropdown
{
    return self.regions.count;
}

-(NSString *)homeDropdown:(HMHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row
{
    HMRegion *region = self.regions[row];
    return region.name;
}

-(NSArray *)homeDropdown:(HMHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row
{
    HMRegion *region = self.regions[row];
    return region.subregions;
}

#pragma mark - HMHomeDropdownDelegate
-(void)homeDropdown:(HMHomeDropdown *)homeDropdown didSelectRowInMainTable:(int)mainRow
{
    HMRegion *region = self.regions[mainRow];
    if(region.subregions.count ==0 )
    {
       [HMNotificationCenter postNotificationName:HMRegionDidChangeNotification object:nil userInfo:@{HMSelectRegion : region}];
    }
}

-(void)homeDropdown:(HMHomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subRow InMainTable:(int)mainRow
{
    HMRegion *region = self.regions[mainRow];
    
    [HMNotificationCenter postNotificationName:HMRegionDidChangeNotification object:nil userInfo:@{HMSelectRegion : region,HMSelectSubregionName :region.subregions[subRow]}];
}
@end
