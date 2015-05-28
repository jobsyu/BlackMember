//
//  HMDetailViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMDetailViewController.h"
#import "HMDeal.h"
#import "HMConst.h"
#import "DPAPI.h"
#import "HMRestrictions.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "HMDealTool.h"

@interface HMDetailViewController () <UIWebViewDelegate,DPRequestDelegate>

@property (weak,nonatomic) IBOutlet UIWebView *webView;
@property (weak,nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
- (IBAction)back;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UILabel *descLabel;
- (IBAction)buy;
- (IBAction)collect;
- (IBAction)share;
@property (weak,nonatomic) IBOutlet UIButton *collectButton;
@property (weak,nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak,nonatomic) IBOutlet UIButton *refundableExpireButton;
@property (weak,nonatomic) IBOutlet UIButton *leftTimeButton;

@end

@implementation HMDetailViewController


//-(void)setDeal:(HMDeal *)deal
//{
//    _deal = deal;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景
    self.view.backgroundColor =HMGlobalBg;
    //标题
    self.titleLabel.text = self.deal.title;
    //描述
    self.descLabel.text = self.deal.desc;
    
    //加载网页
    self.webView.hidden = YES;
    [self.webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    
    //随时退，过期退
    NSDateFormatter *frm = [[NSDateFormatter alloc] init];
    [frm setDateFormat:@"yyyy-MM-dd"];
    NSDate *deadtime = [frm dateFromString:self.deal.purchase_deadline];
    deadtime = [deadtime dateByAddingTimeInterval:24*60*60];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDate *now =  [NSDate date];
    NSDateComponents * comps = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:deadtime options:0];
    
    if(comps.day>365)
    {
       [self.leftTimeButton setTitle:@"一年之内不过期" forState:UIControlStateNormal];
    }
    else
    {
        [self.leftTimeButton setTitle:[NSString stringWithFormat:@"%d天%d小时%d分钟",comps.day,comps.hour,comps.minute] forState:UIControlStateNormal];
    }
    
    DPAPI *dpapi = [[DPAPI alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deal_id"] = self.deal.deal_id;
    
    [dpapi requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
    self.collectButton.selected = [HMDealTool isCollected:self.deal];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark DPRequestDelegate
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    self.deal = [HMDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpireButton.selected = self.deal.restrictions.is_refundable;
}

-(void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD showMessage:@"网络繁忙,请稍后再试" toView:self.view];
}

/**
 *  返回控制器支持的方向
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url])
    {
        NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"—"].location +1];
        NSString *url =  [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@",ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    else //加载详细页面
    {
        // 用来拼接所有的JS
        NSMutableString *js = [NSMutableString string];
        // 删除header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        // 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        // 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        
        // 利用webView执行JS
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        // 获得页面
        //        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
        // 显示webView
        webView.hidden = NO;
        // 隐藏正在加载
        [self.loadingView stopAnimating];
    }

}

-(IBAction)collect
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[HMCollectDealKey] = self.deal;
    if(self.collectButton.selected) //取消收藏
    {
        [HMDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showMessage:@"取消收藏" toView:self.view];
        info[HMIsCollectKey] = @NO;
    }
    else
    {
        [HMDealTool addCollectDeal:self.deal];
        [MBProgressHUD showMessage:@"收藏成功" toView:self.view];
        info[HMIsCollectKey] = @YES;
    }
    
    self.collectButton.selected = !self.collectButton.selected;
    
    [HMNotificationCenter postNotificationName:HMCollectStateDidChangeNotification object:nil userInfo:self.deal];
       
}

@end
