//
//  HMMapViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMMapViewController.h"
#import <MapKit/MapKit.h>
#import "UIBarButtonItem+Extension.h"
#import "DPAPI.h"
#import "HMMetaTool.h"
#import "HMDeal.h"
#import "MJExtension.h"
#import "HMCategory.h"
#import "HMBusiness.h"
#import "HMDealAnnotation.h"
#import "HMHomeTopItem.h"
#import "HMConst.h"
#import "HMCategoryViewController.h"

@interface HMMapViewController () <MKMapViewDelegate ,DPRequestDelegate,CLLocationManagerDelegate>
@property (weak,nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)backToUserLocation;
@property (nonatomic,strong) CLGeocoder *coder;
@property (nonatomic,copy) NSString *city;

/** 分类item **/
@property (nonatomic,weak) UIBarButtonItem * categoryItem;
/** 分类popover **/
@property (nonatomic,strong) UIPopoverController *categoryPopover;
@property (nonatomic,copy) NSString *selectedCategoryName;
@property (nonatomic,strong) DPRequest *lastRequest;

@property (nonatomic,strong) CLLocationManager *locationManager;
 @end

@implementation HMMapViewController

-(CLGeocoder *)coder
{
    if(!_coder)
    {
        self.coder = [[CLGeocoder alloc] init];
    }
    return _coder;
}

- (void)viewDidLoad {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
    
    [super viewDidLoad];
    //左边的返回
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    //标题
    self.title = @"地图";
    
    //设置地图跟踪用户的位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //设置左上角的分类菜单
    HMHomeTopItem *categoryTopItem = [HMHomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem =[[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    self.navigationItem.leftBarButtonItems = @[backItem,categoryItem];
    
    //监听分类改变
    [HMNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:HMCategoryDidChangeNotification object:nil];
}

-(void)dealloc
{
    [HMNotificationCenter removeObserver:self];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (
        ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] && status != kCLAuthorizationStatusNotDetermined && status != kCLAuthorizationStatusAuthorizedWhenInUse) ||
        (![_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] && status != kCLAuthorizationStatusNotDetermined && status != kCLAuthorizationStatusAuthorized)
        ) {
        
        NSString *message = @"您的手机目前未开启定位服务，如欲开启定位服务，请至设定开启定位服务功能";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法定位" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        
        [_locationManager startUpdatingLocation];
    }
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)categoryClick
{
   //显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[HMCategoryViewController alloc] init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)categoryDidChange:(NSNotification *)notification
{
    //1.关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    //2.获得要发送给服务器的类型名称
    HMCategory *category = notification.userInfo[HMSelectCategory];
    NSString *subcategoryName = notification.userInfo[HMSelectSubcategoryName];
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) {
        self.selectedCategoryName = category.name;
    }else
    {
        self.selectedCategoryName = subcategoryName;
    }
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    //3.删除之前的所有大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //4.重新发送请求给服务器
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
    //5.更换顶部item的文字
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubtitle:subcategoryName];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(HMDealAnnotation *)annotation
{
   //返回nil,意味着交给系统处理
    if(![annotation isKindOfClass:[HMDealAnnotation class]]) return nil;
    
    //创建大头针控件
    static NSString *ID = @"deal";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    
    //设置模型(位置\标题\子标题)
    annoView.annotation = annotation;
    
    //设置图片
    annoView.image = [UIImage imageNamed:annotation.icon];
    
    return annoView;
}

#pragma mark - MKMapViewDelegate
/**
  * 当用户的位置更新了就会调用一次
  */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //让地图显示到用户所在的位置
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.25, 0.25));
    [mapView setRegion:region animated:YES];
    
    // 经纬度 --> 城市名 : 反地理编码
    // 城市名 --> 经纬度 : 地理编码
    [self.coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) return;
        
        CLPlacemark *pm = [placemarks firstObject];
        NSString *city = pm.locality ? pm.locality : pm.addressDictionary[@"State"];
        self.city = [city substringToIndex:city.length -1];
        
        //第一次发送请求给服务器
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.city == nil)  return;
    
    //发送请求给服务器
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //城市
    params[@"city"] =self.city;
    //类别
    
    //经纬度
    params[@"latiude"] = @(mapView.region.center.latitude);
    params[@"longitude"] =@(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

#pragma mark -请求代理
-(void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request !=self.lastRequest) return;
    
    NSLog(@"请求失败 － %@",error);
}

-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return;
    
    NSArray *deals = [HMDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (HMDeal *deal in deals) {
        //获取团购所属的类型
        HMCategory *category = [HMMetaTool categoryWithDeal:deal];
        
        for (HMBusiness *business in  deal.businesses) {
            HMDealAnnotation *anno = [[HMDealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = category.map_icon;
            
            if ([self.mapView.annotations containsObject:anno]) break;
            
            [self.mapView addAnnotation:anno];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
