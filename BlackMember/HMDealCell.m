//
//  HMDealCell.m
//  BlackMember
//
//  Created by qianfeng on 15/5/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMDealCell.h"
#import "HMDeal.h"
#import "UIImageView+WebCache.h"

@interface HMDealCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *dealNewView;

@end

@implementation HMDealCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDeal:(HMDeal *)deal
{
    _deal = deal;
    //商品图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    //商品标题
    self.titleLabel.text = deal.title;
    //商品描述
    self.descLabel.text = deal.desc;
    
    //现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"¥ %@",deal.current_price];
    NSUInteger NsDot =  [self.currentPriceLabel.text rangeOfString:@"."].location;
    if (NsDot != NSNotFound) {
        //小数点大于两位
        if(self.currentPriceLabel.text.length - NsDot > 3){
            self.currentPriceLabel.text = [self.currentPriceLabel.text substringToIndex:NsDot+3];
        }
    }
    
    //原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥ %@",deal.list_price];
    //已购买数量
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售: %d",deal.purchase_count];
    
    //是否显示新单
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    date.dateFormat = @"yyyy-MM-dd";
    NSString *nowtime = [date stringFromDate:[NSDate date]];

    self.dealNewView.hidden = ([deal.publish_date compare:nowtime] == NSOrderedAscending);
}

-(void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}

@end
