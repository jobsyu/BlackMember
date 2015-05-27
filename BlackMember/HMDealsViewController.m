//
//  HMDealListViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMDealsViewController.h"
#import "HMDealCell.h"
#import "DPAPI.h"
#import "UIView+AutoLayout.h"
#import "HMConst.h"
#import "MJRefresh.h"
#import "HMDeal.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "HMDetailViewController.h"
#import "HMNavigationController.h"

@interface HMDealsViewController () <DPRequestDelegate>

/** 所有团购的数据 */
@property (nonatomic,strong) NSMutableArray *deals;

/** 总数 */
@property (nonatomic,assign) int total_count;

/** 当前页 */
@property (nonatomic,assign) int currentPage;

/** 最后一次请求 */
@property (nonatomic,weak) DPRequest *lastRequest;

/** 没有数据 */
@property (nonatomic,weak) UIImageView * noDataView;
@end

@implementation HMDealsViewController

static NSString * const reuseIdentifier = @"deal";
-(NSMutableArray *)deals
{
    if (!_deals) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

-(UIImageView *)noDataView
{
    if(!_noDataView)
    {
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色
    self.collectionView.backgroundColor = HMGlobalBg;
    
    //register cell class
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMDealCell" bundle:nil]  forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    //向上刷新
    [self.collectionView  addFooterWithTarget:self action:@selector(loadMoreDeals)];
    [self.collectionView  addHeaderWithTarget:self action:@selector(loadNewDeals)];
    // Do any additional setup after loading the view.
}

//加载更多
-(void)loadMoreDeals
{
    self.currentPage++;
    [self loadDeals];
}


//加载第一页
-(void)loadNewDeals
{
    self.currentPage = 1;
    [self loadDeals];
}

#pragma mark 和服务器交互
-(void)loadDeals
{
    DPAPI *dpapi = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self setParameter:params];
    //一页包含几条
    params[@"limit"] =@30;
    
    //页码
    params[@"page"] =@(self.currentPage);
    
    //发送请求
    self.lastRequest = [dpapi requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}


#pragma mark - 初始化
-(instancetype)init
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //cell的尺寸
    [layout setItemSize:CGSizeMake(305, 305)];
    return [self initWithCollectionViewLayout:layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 当屏幕旋转时，设置内间距
 */
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    //根据屏幕宽度设置列数
    NSInteger cols = (size.width == 1024) ? 3 : 2;
    
    //根据列数设置内边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols +1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    //设置每一行的间距
    layout.minimumLineSpacing = inset;
}

#pragma mark DPAPI请求代理事件
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request !=self.lastRequest) return;
    
    self.total_count = [result[@"total_count"] intValue];
    //取出字典
    NSArray *newDeals = [HMDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (self.currentPage == 1) {
        //删除旧的数据
        [self.deals removeAllObjects];
    }
    [self.deals addObjectsFromArray:newDeals];
    
    //刷新表格
    [self.collectionView reloadData];
    
    //结束刷新
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
}

-(void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request != self.lastRequest) return;
    
    //提醒失败
    [MBProgressHUD showMessage:@"网络太忙,请稍后再试" toView:self.view];
    //结束刷新
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    HMLog(@"%@",error);
}


#pragma mark UICollectionDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    self.collectionView.footerHidden = (self.total_count = self.deals.count);
    self.noDataView.hidden = (self.deals.count !=0);
    return self.deals.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMDetailViewController *detailVC = [[HMDetailViewController alloc] init];
    detailVC.deal = self.deals[indexPath.row];
    [self presentViewController:detailVC animated:YES completion:nil];
}


@end
