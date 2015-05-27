//
//  HMSortViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMSortViewController.h"
#import "HMMetaTool.h"
#import "HMSort.h"
#import "UIView+Extension.h"
#import "HMConst.h"

@interface HMSortViewController ()
@end

@implementation HMSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [HMMetaTool sorts];
    NSInteger count = sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 30;
    CGFloat btnStartY = 0;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    
    for (NSInteger i=0; i<count; i++) {
        HMSort *sort= sorts[i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnStartY + i*(btnMargin+btnH), btnW, btnH)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitle:sort.label forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
        
        height =CGRectGetMaxY(btn.frame);
    }
    
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    
    self.preferredContentSize = CGSizeMake(width,height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonClick:(UIButton *)button
{
    [HMNotificationCenter postNotificationName:HMSortDidChangeNotification object:nil userInfo:@{HMSelectSort: [HMMetaTool sorts][button.tag]}];
}

@end
