//
//  TCCitySearchResultViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCCitySearchResultViewController.h"
#import "TCCity.h"
#import "MJExtension.h"
@interface TCCitySearchResultViewController ()
//城市数组344个城市
@property (nonatomic, strong)NSArray* cities;
//由输入的关键字搜索出的城市
@property (nonatomic, strong)NSMutableArray* searchResultCities;

@end

@implementation TCCitySearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cities=[TCCity mj_objectArrayWithFilename:@"cities.plist"];
   
}
//searchText的Set方法
-(void)setSearchText:(NSString *)searchText{
    //先将可变数组清空
    [self.searchResultCities removeAllObjects];
    //先转为小写
    _searchText=searchText.lowercaseString;
    for(TCCity* city in self.cities){
        
        //关键字查询
        if([city.name containsString:_searchText]||[city.pinYin containsString:_searchText]||[city.pinYinHead containsString:_searchText]){
            
            [self.searchResultCities addObject:city];
        }
    }
//    NSLog(@"%@",self.searchResultCities);
 
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.searchResultCities.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier=@"Cel";
    UITableViewCell* cel=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cel==nil){
        cel=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cel.textLabel.text=[self.searchResultCities[indexPath.row] name];

    return cel;
}
//sectionHeader  显示搜索到几个城市
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"快买共搜索到%d个城市",self.searchResultCities.count];
}
//点击选择城市
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //通知中心 将选中的城市名发出去
    [[NSNotificationCenter defaultCenter]postNotificationName:TCCityDidChangeNotification object:nil userInfo:@{TCSelectCityName:[self.searchResultCities[indexPath.row] name]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 懒加载
-(NSMutableArray*)searchResultCities{
    if(!_searchResultCities){
        _searchResultCities=[NSMutableArray array];
    }
    return _searchResultCities;
}

@end
