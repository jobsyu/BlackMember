//
//  HMSearchViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MJRefresh.h"

@interface HMSearchViewController () <UISearchBarDelegate>

@end

@implementation HMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted" ];
    UISearchBar *bar = [[UISearchBar alloc] init];
    bar.delegate = self;
    bar.placeholder = @"请输入关键词";
    
    self.navigationItem.titleView = bar;
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //进入下拉刷新，向服务器发送请求
    [self.collectionView headerBeginRefreshing];
    
    //退出键盘
    [searchBar resignFirstResponder];
}



-(void)setParameter:(NSMutableDictionary *)params
{
    params[@"city"] =self.selectCityName;
    
    UISearchBar *bar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = bar.text;
}

@end
