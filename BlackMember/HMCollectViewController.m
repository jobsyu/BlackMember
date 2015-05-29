//
//  HMCollectViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/28.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMCollectViewController.h"
#import "HMConst.h"
#import "HMDealCell.h"
#import "HMDeal.h"
#import "UIView+AutoLayout.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDealTool.h"
#import "MJRefresh.h"
#import "HMDetailViewController.h"

@interface HMCollectViewController () <HMDealCellDelegate>


@property (nonatomic,strong) UIBarButtonItem *backBarItem;
@property (nonatomic,strong) UIBarButtonItem *selectAllItem;
@property (nonatomic,strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic,strong) UIBarButtonItem *deleteBarItem;

@property (nonatomic,assign) int currentPage;

@property (nonatomic,strong) NSMutableArray *deals;
@property (nonatomic,weak) UIImageView *noDataView;
@end

@implementation HMCollectViewController

static NSString * const reuseIdentifier = @"deal";

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //cell的尺寸
    [layout setItemSize:CGSizeMake(305, 305)];
    return [self initWithCollectionViewLayout:layout];
}


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
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

-(UIBarButtonItem *)backBarItem
{
    if (!_backBarItem) {
        self.backBarItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backBarItem;
}

-(void)loadMoreDeals
{
    self.currentPage++;
    //获取从fmdb保存的sqlite数据
    [self.deals addObjectsFromArray:[HMDealTool collectDeals:self.currentPage]];
    
    //刷新表格
    [self.collectionView reloadData];
    
    //停止上啦刷新
    [self.collectionView footerEndRefreshing];
}

- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:HMString(@"全选") style:UIBarButtonItemStyleDone target:self action:@selector(selectallClick)];
        
    }
    return _selectAllItem;
}

-(UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:HMString(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unSelectallClick)];
    }
    return _unselectAllItem;
}

-(UIBarButtonItem *)deleteBarItem
{
    if(!_deleteBarItem)
    {
        self.deleteBarItem = [[UIBarButtonItem alloc] initWithTitle:HMString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(deleteClick)];
        self.deleteBarItem.enabled = NO;
    }
    return _deleteBarItem;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = HMGlobalBg;
    
    self.title = @"收藏的团购";
    
    self.navigationItem.leftBarButtonItems = @[self.backBarItem];
    
    //设置导航栏内容
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:HMedit style:UIBarButtonItemStyleDone target:self action:@selector(editClick:)];
    
    //register cell class
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    // 加载第一页的收藏数据
    [self loadMoreDeals];
    
    //监听收藏状态改变的通知
    [HMNotificationCenter addObserver:self selector:@selector(collectDidChanged:) name:HMCollectStateDidChangeNotification object:nil];
    //添加上啦加载
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击全选
-(void)selectallClick
{
    for (HMDeal *deal in self.deals) {
        deal.checking = YES;
    }
    
    //刷新表格
    [self.collectionView reloadData];
    
  
    self.deleteBarItem.enabled = YES;
}

//点击全不选
-(void)unSelectallClick
{
    for (HMDeal *deal in self.deals) {
        deal.checking = NO;
    }
    
    //刷新表格
    [self.collectionView reloadData];
    
    
    self.deleteBarItem.enabled = NO;
}

//删除
-(void)deleteClick
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (HMDeal *deal in self.deals) {
        if (deal.isChecking) {
            [HMDealTool removeCollectDeal:deal];
            
            [tempArray addObject:deal];
        }
    }
    [self.deals removeObjectsInArray:tempArray];
    
    [self.collectionView reloadData];
    
    self.deleteBarItem.enabled =NO;
}

//点击编辑
-(void)editClick:(UIBarButtonItem *)Item
{
    if([Item.title isEqualToString:HMedit])
    {
        Item.title = HMdone;
        self.navigationItem.leftBarButtonItems = @[self.backBarItem,self.selectAllItem,self.unselectAllItem,self.deleteBarItem];
        for (HMDeal *deal in self.deals) {
            deal.editing = YES;
        }
        
    }
    else
    {
        Item.title = HMedit;
        self.navigationItem.leftBarButtonItems = @[self.backBarItem];
        for (HMDeal *deal in self.deals) {
            deal.editing = NO;
        }
    }
    
    [self.collectionView reloadData];
}

-(void)collectDidChanged:(NSNotification *)notification
{
//{
//    if ([notification.userInfo[HMIsCollectKey] boolValue]) {
//        [HMDealTool addCollectDeal:notification.userInfo[HMCollectDealKey]];
//    }
//    else
//    {
//        [HMDealTool removeCollectDeal:notification.userInfo[HMCollectDealKey]];
//    }
    
    
    
    //删掉所有缓存
    [self.deals removeAllObjects];
    
    //
    self.currentPage = 0;
    [self loadMoreDeals];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    //根据屏幕宽度决定列数
    int cols = (size.width == 1024) ? 3 : 2;
    
    //根据列数计算内边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    //设置每一行之间的间距
    layout.minimumLineSpacing = 50;
}

#pragma mark <HMDealCellDelegate>
-(void)dealCellCheckingStateDidChange:(HMDealCell *)cell
{
    BOOL hasChecking = NO;
    for (HMDeal *deal in self.deals) {
        if (deal.isChecking) {
            hasChecking = YES;
            break;
        }
    }
//    for (int i=0; i<self.deals.count; i++) {
//        HMDeal *deal = self.deals[i];
//        if (deal.isChecking) {
//            self.deleteBarItem.enabled =YES;
//            break;
//        }
//    }
}

#pragma mark <UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [self viewWillTransitionToSize:CGSizeMake(self.collectionView.width, 0) withTransitionCoordinator:nil];
    
    self.collectionView.footerHidden = (self.deals.count == [HMDealTool collectDealsCount]);
    self.noDataView.hidden = (self.deals.count != 0);
    return self.deals.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deal = self.deals[indexPath.item];
    cell.delegate = self;
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMDetailViewController *detailVC  = [[HMDetailViewController alloc] init];
    detailVC.deal = self.deals[indexPath.item];
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

@end
