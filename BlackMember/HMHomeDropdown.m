//
//  HMDropdownMenuItem.m
//  BlackMember
//
//  Created by qianfeng on 15/5/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMHomeDropdown.h"
#import "HMDropdownMainCell.h"
#import "HMDropdownSubCell.h"

@interface HMHomeDropdown()<UITableViewDelegate,UITableViewDataSource>
/** 主表 */
@property (weak,nonatomic) IBOutlet UITableView *mainTableView;
/** 从表 */
@property (weak,nonatomic) IBOutlet UITableView *subTableView;

/** 左边主表选中的行号 */
@property (nonatomic,assign) NSInteger selectedMainRow;
@end

@implementation HMHomeDropdown

+(instancetype)dropItem
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMHomeDropdown" owner:nil options:nil] firstObject];
}

-(void)awakeFromNib
{
    //不需要跟随父控件的尺寸变化而伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.mainTableView){
        //返回左边表格的行数
        return [self.datasource numberOfRowsInMainTable:self];
    } else {
        //返回左边选中的行对应右边选中的行的行数
        return [self.datasource homeDropdown:self subdataForRowInMainTable:self.selectedMainRow].count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(tableView == self.mainTableView){//左边主表的cell
        cell = [HMDropdownMainCell cellWithTableView:tableView];
        
        //取出模型数据
        cell.textLabel.text = [self.datasource homeDropdown:self titleForRowInMainTable:indexPath.row];
        
        if ([self.datasource respondsToSelector:@selector(homeDropdown:iconForRowInMainTable:)]) {
            cell.imageView.image = [UIImage imageNamed:[self.datasource homeDropdown:self iconForRowInMainTable:indexPath.row]];
        }
        
        if ([self.datasource respondsToSelector:@selector(homeDropdown:selectedIconForRowInMainTable:)]){
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.datasource homeDropdown:self selectedIconForRowInMainTable:indexPath.row]];
        }
        
        NSArray *subdata = [self.datasource homeDropdown:self subdataForRowInMainTable:indexPath.row];
        if(subdata.count){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else { //从表
        cell = [HMDropdownSubCell cellWithTableView:tableView];
        NSArray *subdata = [self.datasource homeDropdown:self subdataForRowInMainTable:self.selectedMainRow];
        cell.textLabel.text = subdata[indexPath.row];
    }
    
    return cell;
}

#pragma mark -代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        //被点击的数据
        self.selectedMainRow = indexPath.row;
        //刷新右边的数据
        //通知代理
        [self.subTableView reloadData];
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInMainTable:indexPath.row];
        }
    }
    else
    {
        //通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInSubTable:InMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInSubTable:indexPath.row InMainTable:self.selectedMainRow];
        }
    }
}

@end
