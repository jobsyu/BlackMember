//
//  HMCitySearchResultViewController.m
//  BlackMember
//
//  Created by qianfeng on 15/5/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMCitySearchResultViewController.h"
#import "HMMetaTool.h"
#import "HMCity.h"
#import "HMConst.h"

@interface HMCitySearchResultViewController ()
@property (nonatomic,strong) NSArray *resultCities;
@end

@implementation HMCitySearchResultViewController


-(void)setSearchText:(NSString *)searchText
{
    _searchText =[searchText copy];
    
    searchText =searchText.lowercaseString;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];
    self.resultCities = [[HMMetaTool cities] filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultCities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    HMCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%d个结果", self.resultCities.count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMCity * city =  self.resultCities[indexPath.row];
    //发出通知
    [HMNotificationCenter postNotificationName:HMCityDidChangeNotification object:nil userInfo:@{HMSelectCityName :city.name }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
