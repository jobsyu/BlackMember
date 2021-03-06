//
//  HMDealsViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMHomeViewController.h"
#import "HMHomeTopItem.h"
#import "UIBarButtonItem+Extension.h"
#import "HMCity.h"
#import "HMRegion.h"
#import "HMConst.h"
#import "HMHomeDropdown.h"
#import "HMCategoryViewController.h"
#import "HMRegionViewController.h"
#import "HMMetaTool.h"
#import "HMSortViewController.h"
#import "HMSort.h"
#import "HMCategory.h"
#import "HMRegion.h"
#import "HMDeal.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "HMDealCell.h"
#import "AwesomeMenu.h"
#import "UIView+AutoLayout.h"
#import "HMNavigationController.h"
#import "HMCollectViewController.h"
#import "HMRecentViewController.h"
#import "HMSearchViewController.h"
#import "HMMapViewController.h"

@interface HMHomeViewController ()<AwesomeMenuDelegate>

//** 顶部菜单 */
//** 分类菜单 */
@property (weak,nonatomic) UIBarButtonItem * categoryItem;
/** 区域菜单 */
@property (weak,nonatomic) UIBarButtonItem * regionItem;
/** 排序菜单 */
@property (weak,nonatomic) UIBarButtonItem * sortItem;


/** 当前选中的城市名 */
@property (nonatomic,copy) NSString *selectedCityName;

/** 当前选中的区域 */
@property (nonatomic,copy) NSString *selectedRegion;

/** 当前选中的类别 */
@property (nonatomic,copy) NSString *selectedCategory;

/** 当前选中的排序 */
@property (nonatomic,strong) HMSort *selectedSort;


/** 区域Popover */
@property (nonatomic,strong) UIPopoverController *regionPopover;
/** 类别Popover */
@property (nonatomic,strong) UIPopoverController *categoryPopover;
/** 排序Popover */
@property (nonatomic,strong) UIPopoverController *sortPopover;


@end

@implementation HMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏左边的内容
    [self setupNavLeft];
    //设置导航栏右边的内容
    [self setupNavRight];
    
    //创建awesomemenu
    [self setupAwesomeMenu];
}

-(void)viewDidAppear:(BOOL)animated
{
    //[super viewDidAppear:animated];
    [super viewDidAppear:animated];
    
    [self setupNotification];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [HMNotificationCenter removeObserver:self];
}

/** 设置监听 */
-(void)setupNotification
{
    //监听城市改变
    [HMNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:HMCityDidChangeNotification object:nil];
    
    //监听类别改变
    [HMNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:HMCategoryDidChangeNotification object:nil];
    
    //监听类别改变
    [HMNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:HMRegionDidChangeNotification object:nil];
    
    //监听排序改变
    [HMNotificationCenter addObserver:self selector:@selector(sortDidChange:) name:HMSortDidChangeNotification object:nil];
}

-(void)setupAwesomeMenu
{
    //1.中间的item
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:nil];
    
    //2.周边的item
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    NSArray *items = @[item0,item1,item2,item3];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:items];
    menu.alpha = 0.5;
    //设置菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    //设置开始按钮的位置
    menu.startPoint = CGPointMake(50, 150);
    //设置代理
    menu.delegate = self;
    //不要旋转中间按钮
    menu.rotateAddButton = NO;
    [self.view addSubview:menu];
    
    //设置菜单永远在左下角
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [menu autoSetDimensionsToSize:CGSizeMake(200, 200)];
}

#pragma mark -AwesomeMenuDelegate
-(void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{
    //替换菜单的图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    
    //完全显示
    menu.alpha = 1.0;
    
}

-(void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    //替换菜单的图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    
    //半透明显示
    menu.alpha = 0.5;
    
}

-(void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    //半透明显示
    menu.alpha= 0.5;
    
    //替换菜单的图片
    menu.contentImage = [ UIImage imageNamed:@"icon_pahMenu_main_Mine_normal"];
    
    switch (idx) {
        case 0: { //收藏
            HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:[[HMCollectViewController alloc] init]];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        
        case 1: { //最近访问记录
            HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:[[HMRecentViewController alloc] init]];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
   
        default:
            break;
    }
}

/** 设置请求参数 实现父类的方法 */
-(void)setParameter:(NSMutableDictionary *)params
{
    //城市
    params[@"city"] = self.selectedCityName;
    //分类
    if(self.selectedCategory)
    {
        params[@"category"] = self.selectedCategory;
    }
    
    //区域
    if(self.selectedRegion)
    {
        params[@"region"] = self.selectedRegion;
    }
    
    //排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort.value);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 监听事件

/**
  * 城市改变监听事件回调
  */
-(void)cityDidChange:(NSNotification *)notification
{
    self.selectedCityName = notification.userInfo[HMSelectCityName];
    
    //更新顶部区域item的文字
    HMHomeTopItem *homeTopItem = (HMHomeTopItem *)self.regionItem.customView;
    [homeTopItem setTitle:[NSString stringWithFormat:@"%@ - 全部",self.selectedCityName]];
    [homeTopItem setSubtitle:nil];
    
    [self.collectionView headerBeginRefreshing];
    //[self loadNewsDeals];
}

/**
 * 类别改变监听事件回调
 */
-(void)categoryDidChange:(NSNotification *)notification
{
    HMCategory *category = notification.userInfo[HMSelectCategory];
    NSString  *subCategoryName = notification.userInfo[HMSelectSubcategoryName];
    
    if(subCategoryName ==nil || [subCategoryName isEqualToString:@"全部"])
    {
        self.selectedCategory = category.name;
    }
    else {
        self.selectedCategory = subCategoryName;
    }
    
    if([self.selectedCategory isEqualToString:@"全部分类"])
    {
        self.selectedCategory =nil;
    }
    
    //更新顶部区域item的文字
    HMHomeTopItem *homeTopItem = (HMHomeTopItem *)self.categoryItem.customView;
    [homeTopItem setTitle:category.name];
    [homeTopItem setSubtitle:subCategoryName];
    [homeTopItem setIcon:category.icon highIcon:category.highlighted_icon];
    
    //关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    [self.collectionView headerBeginRefreshing];
    //加载数据
    //[self loadNewsDeals];
}

/**
 * 区域改变监听事件回调
 */
-(void)regionDidChange:(NSNotification *)notification
{
    HMRegion *region = notification.userInfo[HMSelectRegion];
    NSString *subRegionName = notification.userInfo[HMSelectSubregionName];
    
    if(subRegionName == nil || [subRegionName isEqualToString:@"全部"])
    {
        self.selectedRegion = region.name;
    }
    else
    {
        self.selectedRegion = subRegionName;
    }
    
    if([self.selectedRegion isEqualToString:@"全部"])
    {
        self.selectedRegion = nil;
    }
    
    //更新顶部区域item的文字
    HMHomeTopItem *homeTopItem = (HMHomeTopItem *)self.regionItem.customView;
    [homeTopItem setTitle:[NSString stringWithFormat:@"%@ - %@",self.selectedCityName,region.name]];
    [homeTopItem setSubtitle:subRegionName];
    
    //关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    
    //加载数据
    //[self loadNewsDeals];
    [self.collectionView headerBeginRefreshing];
}



/**
 * 城市改变监听事件回调
 */
-(void)sortDidChange:(NSNotification *)notification
{
    self.selectedSort = notification.userInfo[HMSelectSort];
    
    //更新顶部区域item的文字
    HMHomeTopItem *homeTopItem = (HMHomeTopItem *)self.sortItem.customView;
    [homeTopItem setSubtitle:self.selectedSort.label];
    
    [self.sortPopover dismissPopoverAnimated:YES];
    
    [self.collectionView headerBeginRefreshing];
    //[self loadNewsDeals];
}

#pragma mark - 设置导航栏
/** 
  * 设置导航栏左边的内容
  */

-(void)setupNavLeft
{
    //1.LOGO
    UIBarButtonItem *logoItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_meituan_logo" highImage:@"icon_meituan_logo"];
    logoItem.customView.userInteractionEnabled = NO;
    
    //2.分类
    HMHomeTopItem *categoryTopItem = [HMHomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    
    //3.区域
    HMHomeTopItem *regionTopItem = [HMHomeTopItem item];
    [regionTopItem addTarget:self action:@selector(regionClick)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:regionTopItem];
    self.regionItem = regionItem;
    
    // 4.排序
    HMHomeTopItem *sortTopItem = [HMHomeTopItem item];
    [sortTopItem setTitle:@"排序"];
    [sortTopItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sortTopItem addTarget:self action:@selector(sortClick)];
    
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem =sortItem;
    
    self.navigationItem.leftBarButtonItems =@[logoItem,categoryItem,regionItem, sortItem];
}

/** 
  * 设置导航栏右边的内容
  */
-(void)setupNavRight
{
    //1.地图
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(mapClick) image:@"icon_map" highImage:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    //2.搜索
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClick) image:@"icon_search" highImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
}

-(void)categoryClick
{
    //显示分类菜单
    self.categoryPopover =[[UIPopoverController alloc] initWithContentViewController:[[HMCategoryViewController alloc] init]];
    
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
   
}

-(void)regionClick
{
    HMRegionViewController *region = [[HMRegionViewController alloc] init];
    if (self.selectedCityName) {
        //获取当前城市
        HMCity *city = [[[HMMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name =%@",self.selectedCityName]] firstObject];
        region.regions = city.regions;
    }
    
    self.regionPopover = [[UIPopoverController alloc] initWithContentViewController:region];
    [self.regionPopover presentPopoverFromBarButtonItem:self.regionItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    region.popover = self.regionPopover;
}

-(void)sortClick
{
    HMSortViewController *sort = [[HMSortViewController alloc] init];
    
    self.sortPopover  = [[UIPopoverController alloc] initWithContentViewController:sort];
    [self.sortPopover presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)mapClick
{
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:[[HMMapViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)searchClick
{
    if (self.selectedCityName) {
        HMSearchViewController *searchVC = [[HMSearchViewController alloc] init];
        searchVC.selectCityName = self.selectedCityName;
        
        HMNavigationController  *nav = [[HMNavigationController alloc] initWithRootViewController:searchVC];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        [MBProgressHUD showMessage:@"请选择城市后再搜索" toView:self.view];
    }
}

@end
