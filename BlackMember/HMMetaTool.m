//
//  HMMetaTool.m
//  BlackMember
//
//  Created by qianfeng on 15/5/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HMMetaTool.h"
#import "HMCategory.h"
#import "MJExtension.h"
#import "HMCity.h"
#import "HMSort.h"
#import "HMDeal.h"

@implementation HMMetaTool

//+(NSArray *)categories
//{
//    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
//    
//    NSMutableArray *arrays = [NSMutableArray array];
//    for (int i=0; i<array.count; i++) {
//        
//        NSDictionary *dict = array[i];
//        
//        HMCategory *categories = [[HMCategory alloc] init];
//        categories.name = [dict objectForKey:@"name"];
//        categories.icon = [dict objectForKey:@"icon"];
//        categories.small_icon = [dict objectForKey:@"small_icon"];
//        categories.small_highlighted_icon = [dict objectForKey: @"small_highlighted_icon"];
//        categories.highlighted_icon = [dict objectForKey:@"highlighted_icon"];
//        if ([[dict allKeys] containsObject:@"subcategories"]) {
//            categories.subcategories = [dict objectForKey:@"subcategories"];
//        }
//        else
//        {
//            categories.subcategories =nil;
//        }
//        [arrays addObject:categories];
//    }
//    return arrays;
//}

static NSArray *_categories;
+ (NSArray *)categories
{
   if(_categories == nil)
   {
       _categories = [HMCategory objectArrayWithFilename:@"categories.plist"];
   }
   return _categories;
}


static NSArray *_cities;
+(NSArray *)cities
{
   if(_cities == nil)
   {
       _cities = [HMCity objectArrayWithFilename:@"cities.plist"];
   }
   return _cities;
}

static NSArray *_sorts;
+(NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [HMSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

+(HMCategory *)categoryWithDeal:(HMDeal *)deal
{
    NSArray *cs = [self categories];
    NSString *cname = [deal.categories firstObject];
    for (HMCategory *c in cs) {
        if ([cname isEqualToString:c.name]) return c;
        if ([c.subcategories containsObject:cname]) return c;
        
    }
    return nil;
}

@end
