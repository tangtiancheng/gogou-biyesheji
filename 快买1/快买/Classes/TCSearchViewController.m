//
//  TCSearchViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCSearchViewController.h"
#import "TCDealCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "DPAPI.h"
#import "TCDeal.h"
#import "UIView+AutoLayout.h"
#import "TCDetailViewController.h"
#import "TCDealTool.h"

@interface TCSearchViewController ()<UISearchBarDelegate,DPRequestDelegate,UIScrollViewDelegate>

//第几页
@property(nonatomic,assign)int page;
/**  搜索到的所有的团购数据 **/
@property (nonatomic, strong)NSMutableArray* deals;
//背景图片
@property (nonatomic, strong)UIImageView* imageView;
//searchBar
@property (nonatomic, strong)NSString* searchBarText;

//最后一次请求(目的是防止上一次请求覆盖掉下一次请求,照成数据错误)
@property (nonatomic, strong)DPRequest* lastRequest;

@end

@implementation TCSearchViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor=TCGlobalBg;
    self.page=1;
    self.imageView.hidden=NO;
    
    //左边的返回
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemImage:@"icon_back" highlightedImage:@"icon_back_highlighted" target:self action:@selector(back)];
    
    // 中间的搜索框
    UISearchBar* searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入关键词";
    searchBar.backgroundImage=[UIImage imageNamed:@"bg_login_textfield"];
    searchBar.delegate = self;
    self.navigationItem.titleView=searchBar;
    
    //设置下拉刷新/上拉加载更多
    self.collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=1;
        [self loadNewDeals];
    }];
    self.collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadNewDeals];
    } ];

    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"TCDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
}

//左边返回
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark loadNewDeals(跟服务器进行交互)
-(void)loadNewDeals{
    DPAPI* api=[[DPAPI alloc]init];
    
    NSMutableDictionary* params=[NSMutableDictionary dictionary];
    
    // 每页的条数
    params[@"limit"] = @15;
    //第几页
    params[@"page"]=@(self.page);
    //城市
    params[@"city"]=self.cityName;
    //搜索关键字
    params[@"keyword"]=self.searchBarText;
    
    //发送请求
    self.lastRequest=[api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    NSLog(@"请求参数:%@",params);
}
//请求成功
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    //如果不是最后一次请求的返回结果,则啥事不干
    if(self.lastRequest!=request)return;

    
    NSArray* deals=[TCDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]];
    if(deals.count!=0){
        self.imageView.hidden=YES;
    }else{
        self.imageView.hidden=NO;
    }
    if(self.page==1){
        self.deals=deals;
        [self.collectionView.mj_header endRefreshing];
    }else{//如果page!=1,则表示是加载更多,则拼接数组
        [self.deals addObjectsFromArray:deals];
        [self.collectionView.mj_footer endRefreshing];
    }
    [self.collectionView reloadData];
    
    
}
//请求失败
-(void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    //如果不是最后一次请求的返回结果,则啥事不干
    if(self.lastRequest!=request)return;

       if(self.page==1){
        //结束刷新
        [self.collectionView.mj_header endRefreshing];
    }else{
        //结束刷新
        [self.collectionView.mj_footer endRefreshing];
    }
    //1.提醒失败
    [MBProgressHUD showError:@"网络繁忙,请稍后重试" toView:self.view];
    // 3.如果是上拉加载失败了
    if (self.page > 1) {
        self.page--;
    }

}


#pragma mark UISearchBarDelegate
//点击发送按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchBarText=searchBar.text;
    //将page重新为1
    self.page=1;
    //发送请求
    [self loadNewDeals];
    //移除第一响应者,即键盘弹下来
    [searchBar resignFirstResponder];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.deals.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deal=self.deals[indexPath.row];
    // Configure the cell
    return cell;
    
    return cell;
}
#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TCDetailViewController *detailVc = [[TCDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
    //如果之前没浏览过,则加入数据库
    if(![TCDealTool isBrowsered:self.deals[indexPath.item]]){
        [TCDealTool addBrowserDeal:self.deals[indexPath.item]];
    }
}

#pragma mark <UICollectionViewDelegate>
#pragma mark <UIScrollerViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滚动时键盘弹下
    UISearchBar* searchBar=self.navigationItem.titleView;
    //将文字清空
    searchBar.text=nil;
    [searchBar resignFirstResponder];
}

#pragma mark- 懒加载
//所有的团购数据
-(NSMutableArray*)deals{
    if(!_deals){
        _deals=[NSMutableArray array];
    }
    return _deals;
}

//背景图片
-(UIImageView*)imageView{
    if(!_imageView){
        _imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        
        [self.collectionView addSubview:_imageView];
        //自动居中
        [_imageView autoCenterInSuperview];
    
    }
    return _imageView;
}



@end
