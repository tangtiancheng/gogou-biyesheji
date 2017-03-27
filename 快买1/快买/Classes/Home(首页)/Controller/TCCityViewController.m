//
//  TCCityViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCCityViewController.h"
#import "TCCityGroup.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "TCCitySearchResultViewController.h"

@interface TCCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
//遮罩
@property (nonatomic, strong)UIView* coverView;

//城市数组
@property (nonatomic, strong)NSArray* cityGroups;

//搜索结果控制器
@property (nonatomic, strong)TCCitySearchResultViewController* citySearchResult;

@end

@implementation TCCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.self.view);
        make.height.equalTo(@100);
    }];
    self.searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100) ;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_dropdown_left_selected"];
    self.searchBar.placeholder = @"亲输入";
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
    
    
    
    self.title=@"选择城市";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemImage:@"btn_navigation_close" highlightedImage:@"btn_navigation_close_hl" target:self action:@selector(close)];
    self.cityGroups=[TCCityGroup mj_objectArrayWithFilename:@"cityGroups.plist"];
    // Do any additional setup after loading the view from its nib.
}
-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark TableViewDataSource TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cityGroups.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TCCityGroup* cityGroup=self.cityGroups[section];
    return cityGroup.cities.count;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    TCCityGroup* cityGroup=self.cityGroups[section];
    return cityGroup.title;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier=@"Cel";
    UITableViewCell* cel=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cel==nil){
        cel=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TCCityGroup* cityGroup=self.cityGroups[indexPath.section];
    NSString* cityName=cityGroup.cities[indexPath.row];
    cel.textLabel.text=cityName;
    return cel;
}
//点击城市
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCCityGroup* cityGroup=self.cityGroups[indexPath.section];
    //通知中心 将选中的城市名发出去
    [[NSNotificationCenter defaultCenter]postNotificationName:TCCityDidChangeNotification object:nil userInfo:@{TCSelectCityName:cityGroup.cities[indexPath.row]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark UISearchBarDelegate
//开始编辑文字,即键盘弹出来那下
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //显示遮罩
    self.coverView.hidden=NO;
//    NSLog(@"%@",self.coverView);
    //显示搜索栏右边的 取消按钮
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
//键盘收回,结束编辑
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //显示隐藏栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //隐藏遮罩
    [self.coverView setHidden:YES];
    //隐藏结果控制器的tableView
    self.citySearchResult.tableView.hidden=YES;
    //将搜索栏内容清空
    self.searchBar.text=nil;
    //隐藏搜索栏右边的 隐藏按钮
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
//搜索框里的文字发生变化,正在编辑
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length){
        self.citySearchResult.tableView.hidden=NO;
        self.citySearchResult.searchText=searchText;
    }else{
        self.citySearchResult.tableView.hidden=YES;
    }
}
//点击了搜索栏右边的 取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

#pragma mark 懒加载
//遮罩懒加载
-(UIView*)coverView{
    if(!_coverView){
        _coverView=[[UIView alloc]init];
        _coverView.frame=self.tableView.frame;
        _coverView.backgroundColor=[UIColor blackColor];
        _coverView.alpha=0.5;
        [self.view addSubview:_coverView];
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self.searchBar action:@selector(resignFirstResponder)]];
        
    }
    return _coverView;
}
//结果控制器懒加载
-(TCCitySearchResultViewController*)citySearchResult{
    if(!_citySearchResult){
        _citySearchResult=[[TCCitySearchResultViewController alloc]init];
        [self addChildViewController:_citySearchResult];
        [self.view addSubview:_citySearchResult.tableView];
        _citySearchResult.tableView.frame=self.tableView.frame;
    }
    return _citySearchResult;
}
-(void)dealloc{
    
}
@end
