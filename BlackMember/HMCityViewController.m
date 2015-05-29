//
//  HMCityViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMCityViewController.h"
#import "HMHomeDropdown.h"
#import "HMCity.h"
#import "HMMetaTool.h"
#import "HMRegion.h"
#import "HMConst.h"
#import "HMCItyGroup.h"
#import "MJExtension.h"
#import "UIBarButtonItem+Extension.h"
#import "HMCitySearchResultViewController.h"
#import "UIView+AutoLayout.h"


@interface HMCityViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)coverClick;

@property (nonatomic,strong) NSArray * cityGroups;
@property (nonatomic,weak) HMCitySearchResultViewController *citySearchResult;
@end

@implementation HMCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换城市";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    //加载城市数据
    self.cityGroups = [HMCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    
    self.searchBar.tintColor = HMColor(32, 191, 179);
}

-(HMCitySearchResultViewController *)citySearchResult
{
    if (!_citySearchResult) {
        HMCitySearchResultViewController *citySearchResult = [[HMCitySearchResultViewController alloc] init];
        [self addChildViewController:citySearchResult];
        self.citySearchResult = citySearchResult;
        
        [self.view addSubview:self.citySearchResult.view];
        
        [self.citySearchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.citySearchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:15];
    }
    return _citySearchResult;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
  * 点击关闭barbutton
  */
-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 搜索框代理方法
/**
  *  键盘弹出, 搜索框开始编辑文字
  */
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //弹出键盘
    [searchBar becomeFirstResponder];
    
    //1.隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //2.修改搜索框背景的背景
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    
    //3.显示搜索框右边的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    //4.显示遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.5;
    }];
}

/**
  * 键盘退出，搜索框结束编辑文字
  */
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //1.显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //2.修改搜索框背景的背景
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    
    //3.隐藏搜索框右边的取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    //4.隐藏遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.0;
    }];
    
    //移除搜索结果
    self.searchBar.text =nil;
    self.citySearchResult.view.hidden =YES;
}
/**
  *  搜索框里面的文字内容变化时调用
  */
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length)
    {
        self.citySearchResult.view.hidden = NO;
        self.citySearchResult.searchText = searchText;
    }
    else
    {
        self.citySearchResult.view.hidden = YES;
    }
}
/**
  * 点击遮盖
  */
-(IBAction)coverClick
{
    [self.searchBar resignFirstResponder];
}

/**
  * 点击取消按钮
  */
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark 数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return  [self.cityGroups count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HMCityGroup *cityGroup = self.cityGroups[section];
    return [cityGroup.cities count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    HMCityGroup *citygroup = self.cityGroups[indexPath.section];
    cell.textLabel.text = citygroup.cities[indexPath.row];
    
    return cell;
}

#pragma mark 代理方法
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HMCityGroup *citygroup = self.cityGroups[section];
    return citygroup.title;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityGroups valueForKey:@"title"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMCityGroup *ciyGroup = self.cityGroups[indexPath.section];
    //发送通知
    [HMNotificationCenter postNotificationName:HMCityDidChangeNotification object:nil userInfo:@{HMSelectCityName : ciyGroup.cities[indexPath.row]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
