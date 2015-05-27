//
//  HMDealsTopMenu.m
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMHomeTopItem.h"

@interface HMHomeTopItem()

@property (weak,nonatomic) IBOutlet UIButton *imageButton;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation HMHomeTopItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



+(instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMHomeTopItem" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}


-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text =subtitle;
}

-(void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon
{
    [self.imageButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.imageButton setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
}

-(void)addTarget:(id)target action:(SEL)action
{
    [self.imageButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
