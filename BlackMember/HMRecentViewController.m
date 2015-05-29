//
//  HMRecentViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMRecentViewController.h"
#import "HMConst.h"
#import "HMDealTool.h"
#import "MJRefresh.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDeal.h"
#import "HMDealCell.h"
#import "HMDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+AutoLayout.h"

@interface HMRecentViewController ()<HMDealCellDelegate>

@property (nonatomic,strong) UIBarButtonItem *backItem;
@property (nonatomic,strong) UIBarButtonItem *selectAllItem;
@property (nonatomic,strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic,strong) UIBarButtonItem *deleteItem;

@property (nonatomic,strong) NSMutableArray *deals;
@property (nonatomic,weak) UIImageView *noDataView;
@property (nonatomic,assign) int currentPage;

@end

@implementation HMRecentViewController

static NSString * const reuseIdentifier = @"deal";

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
}

-(NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

-(UIImageView *)noDataView
{
    if (!_noDataView) {
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"icon_latestBrowse_empty"]];
        [self.view addSubview:noDataView];
        [noDataView  autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

//返回
-(UIBarButtonItem *)backItem
{
    if (!_backItem) {
        self.backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近浏览";
    self.collectionView.backgroundColor = HMGlobalBg;
    
    self.navigationItem.leftBarButtonItems =@[self.backItem];
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMDealCell" bundle:nil]  forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical =YES;
    //刷新第一页的数据
    [self loadMoreData];
    
    //显示导航栏右边的按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:HMedit style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    //[HMNotificationCenter addObserver:self selector:@selector(recentStateChange:) name:HMRecentStateDidChangeNotification object:nil];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    // Do any additional setup after loading the view.
}
//点击编辑
-(void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:HMedit]) {
        item.title = HMdone;
        self.navigationItem.leftBarButtonItems =@[self.backItem ,self.selectAllItem,self.unselectAllItem,self.deleteItem];
        
        for (HMDeal *deal in self.deals) {
            deal.editing = YES;
        }
    }
    else
    {
        item.title = HMedit;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        for (HMDeal *deal in self.deals) {
            deal.editing = NO;
        }
    }
    
    [self.collectionView reloadData];
}

//全选
-(UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:HMString(@"全选") style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}
-(void)selectAll
{
    for (HMDeal *item in self.deals) {
        item.checking = YES;
    }
    
    self.deleteItem.enabled =YES;
    
    [self.collectionView reloadData];
    
}

-(UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:HMString(@"不全选") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}

-(void)unselectAll
{
    for (HMDeal *item in self.deals) {
        item.checking = NO;
    }
    
    self.deleteItem.enabled = NO;
    
    [self.collectionView reloadData];
}

-(UIBarButtonItem *)deleteItem
{
    if (!_deleteItem) {
        self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:HMString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
        self.deleteItem.enabled =NO;
    }
    return _deleteItem;
}

-(void)delete{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (HMDeal *item in self.deals) {
        if (item.isChecking) {
            [HMDealTool removeRecentDeal:item];
            
            [tempArray addObject:item];
        }
    }
    
    [self.deals removeObjectsInArray:tempArray];
    
    [self.collectionView reloadData];
}
-(void)loadMoreData
{
    self.currentPage++;
    
    //获取fmdb里面t_collect_recent的表的数据
    [self.deals  addObjectsFromArray:[HMDealTool recentDeals:self.currentPage]];
    
    //刷新表格
    [self.collectionView reloadData];
    
    //停止刷新
    [self.collectionView footerEndRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    //根据屏幕的宽度设置列数
    int cols = (self.collectionView.width == 1024) ? 3 : 2;
    
    //根据列数设置间距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (self.collectionView.width - cols*layout.itemSize.width)/(cols +1);
    
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    //设置每一行的间距
    layout.minimumLineSpacing =50;
    
}

#pragma mark <HMCellDelegate>
-(void)dealCellCheckingStateDidChange:(HMDealCell *)cell
{
    BOOL hasChecking = NO;
    for (HMDeal *deal in self.deals) {
        if (deal.isChecking) {
            hasChecking = YES;
            break;
        }
    }
    
    // 根据有没有打钩的情况,决定删除按钮是否可用
    self.deleteItem.enabled = hasChecking;
    
//    for (HMDeal *deal in self.deals) {
//        if (deal.isChecking) {
//            self.deleteItem.enabled = YES;
//        }
//    }
//    
//    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the sectio
    [self viewWillTransitionToSize:CGSizeMake(self.collectionView.width, 0) withTransitionCoordinator:nil];
    
    self.collectionView.footerHidden = (self.deals.count == [HMDealTool recentDealsCount]);
    
    self.noDataView.hidden = (self.deals.count !=0);
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HMDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    cell.delegate =self;
    // Configure the cell
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMDetailViewController *detailVC = [[HMDetailViewController alloc] init];
    detailVC.deal = self.deals[indexPath.item];
    [self presentViewController:detailVC animated:YES completion:nil];
}

@end
