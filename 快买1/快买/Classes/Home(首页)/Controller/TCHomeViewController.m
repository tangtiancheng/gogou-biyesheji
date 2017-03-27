//
//  TCHomeViewController.m
//  快买
//
//  Created by 唐天成 on 15/12/28.
//  Copyright © 2015年 唐天成. All rights reserved.
//

#import "TCHomeViewController.h"
#import "TCHomeTopItem.h"
#import "TCCategoryViewController.h"
#import "TCDistrictViewController.h"
#import "TCSortViewController.h"
#import "TCSort.h"
#import "DPAPI.h"
#import "TCDeal.h"
#import "TCDealCell.h"
#import "MJExtension.h"
#import "TCWaterFlowLayout.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "TCSearchViewController.h"
#import "TCNavigationController.h"
#import "TCSearchNavigationController.h"
#import "AwesomeMenu.h"
#import "Masonry.h"
#import "TCDetailViewController.h"
#import "Masonry.h"
#import "TCCollectViewController.h"
#import "TCAllShareViewController.h"
#import "TCMapViewController.h"
#import "TCDPAPIHttpTool.h"
#import "TCBrowserViewController.h"
#import "TCDealTool.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "TCShareMessage.h"

@interface TCHomeViewController ()<DPRequestDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AwesomeMenuDelegate>

/**CollectionView**/
@property (nonatomic, strong)UICollectionView* collectionView;


/** 分类item */
@property (nonatomic, strong)TCHomeTopItem* categoryItem;
/** 地区item */
@property (nonatomic, strong)TCHomeTopItem* districtItem;
/** 排序item */
@property (nonatomic, strong)TCHomeTopItem* sortItem;

/** 当前选中的分类名字 */
@property (nonatomic, copy) NSString *selectedCategoryName;
/** 当前选中的城市 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 当前选中的区域名字 */
@property (nonatomic, copy) NSString *selectedRegionName;
/** 当前选中的排序 */
@property (nonatomic, strong) TCSort *selectedSort;


/** 分类popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;
/** 区域popover */
@property (nonatomic, strong) UIPopoverController *regionPopover;
/** 排序popover */
@property (nonatomic, strong) UIPopoverController *sortPopover;

/**  所有的团购数据 **/
@property (nonatomic, strong)NSMutableArray* deals;

//返回的页码
@property(nonatomic,assign)int page;
//背景图片
@property (nonatomic, strong)UIImageView* imageView;

//最后一次请求(目的是防止上一次请求覆盖掉下一次请求,照成数据错误)
@property (nonatomic, strong)DPRequest* lastRequest;


@end

@implementation TCHomeViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
//    UIAlertController* alertController=[UIAlertController alertControllerWithTitle:@"快买" message:@"该项目为兰州交通大学计算机专业毕业设计\n设计学生 : 唐天成" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [alertController dismissViewControllerAnimated:YES completion:nil];
//    });
    
    self.collectionView.alwaysBounceVertical = YES;
    self.title=@"欢迎来到快买";
    self.page=1;
    //注册TCdealCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"TCDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier ];
    self.imageView.hidden=NO;
    
#warning 以下是监听通知
    //选择分类发生变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(categoryDidChange:) name:TCCategoryDidChangeNotification object:nil];
    //选择城市发生变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityDidChange:) name:TCCityDidChangeNotification object:nil];
    //选择区域发生变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regionDidChange:) name:TCRegionDidChangeNotification object:nil];
    //排序方式发生变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sortDidChange:) name:TCSortDidChangeNotification object:nil];
    
    //设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
    
    //设置下拉刷新/上拉加载更多
    self.collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=1;
        [self loadNewDeals];
    }];
    self.collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadNewDeals];
    } ];
    
    //设置awesomeMenu菜单,就是右下角那个很炫的菜单
    [self setupAwesomeMenu];
    
}

#pragma mark- 监听到通知(City  Region  Category  Sort)
//选择分类发生变化
-(void)categoryDidChange:(NSNotification*)notificarion{
    NSDictionary* userInfo=notificarion.userInfo;
    self.categoryItem.titleLabel.text=userInfo[TCSelectCategoryName];
    self.categoryItem.subTitleLabel.text=userInfo[TCSelectSubCategoryName];
    
    //如果子分类为nil或子分类为 "全部"
    if(userInfo[TCSelectSubCategoryName]==nil||[userInfo[TCSelectSubCategoryName] isEqualToString:@"全部"]){
        if([userInfo[TCSelectCategoryName] isEqualToString:@"全部分类"]){
            self.selectedCategoryName=nil;
        }else{
            self.selectedCategoryName=userInfo[TCSelectCategoryName];
        }
    }else{
        self.selectedCategoryName=userInfo[TCSelectSubCategoryName];
    }
    self.page=1;
    //关闭Popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    //发送请求
    [self.collectionView.mj_header beginRefreshing];
}
//选择城市发生变化通知
-(void)cityDidChange:(NSNotification*)notification{
    self.selectedCityName=notification.userInfo[TCSelectCityName];
    self.selectedRegionName=nil;
   
    self.districtItem.titleLabel.text=[NSString stringWithFormat:@"%@-全部",self.selectedCityName];
    self.districtItem.subTitleLabel.text=@"--";
    self.page=1;
    //发送请求
    [self.collectionView.mj_header beginRefreshing];
}
//选择区域发生变化
-(void)regionDidChange:(NSNotification*)notification{
    NSDictionary* userInfo=notification.userInfo;
    self.districtItem.titleLabel.text=[NSString stringWithFormat:@"%@-%@",self.selectedCityName,userInfo[TCSelectRegionName]];
    self.districtItem.subTitleLabel.text=userInfo[TCSelectSubregionName];
    NSLog(@"%@",userInfo[TCSelectSubregionName]);
    //如果没有子区域 或 子区域为"全部"
    if(userInfo[TCSelectSubregionName]==nil||[userInfo[TCSelectSubregionName] isEqualToString:@"全部"]){
        //如果区域为 @"全部"
        if([userInfo[TCSelectRegionName] isEqualToString:@"全部"]){
            self.selectedRegionName=nil;
        }else{//如果区域不是 @"全部"
            self.selectedRegionName=userInfo[TCSelectRegionName];
        }
    }else{//如果有子区域且不为  @"全部"
        self.selectedRegionName=userInfo[TCSelectSubregionName];
    }
    self.page=1;
    //关闭Popover
    [self.regionPopover dismissPopoverAnimated:YES];
    //发送请求
    [self.collectionView.mj_header beginRefreshing];
}
//排序方式发生变化通知
-(void)sortDidChange:(NSNotification*)notification{
    NSDictionary* userInfo=notification.userInfo;
    self.sortItem.subTitleLabel.text=[userInfo[TCSelectSort] label];
    self.selectedSort=userInfo[TCSelectSort];
    self.page=1;
    //关闭Popover
    [self.sortPopover dismissPopoverAnimated:YES];
    //发送请求
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark loadNewDeals(跟服务器进行交互)
-(void)loadNewDeals{
    
    NSMutableDictionary* params=[NSMutableDictionary dictionary];
    // 每页的条数
    params[@"limit"] = @15;
    params[@"page"]=@(self.page);
    //城市
    params[@"city"]=self.selectedCityName;
    //区域
    if(self.selectedRegionName){
        params[@"region"]=self.selectedRegionName;
    }
    //分类
    if(self.selectedCategoryName){
        params[@"category"]=self.selectedCategoryName;
    }
    //排序
    if(self.selectedSort){
        params[@"sort"]=@(self.selectedSort.value);
    }
    
    //发送请求
    DPAPI* api=[[DPAPI alloc]init];
   self.lastRequest= [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
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


#pragma mark- 设置导航条左右
#pragma mark 设置左边
-(void)setupLeftNav{
    //LOGO
    UIBarButtonItem* logo=[UIBarButtonItem itemImage:@"logo120" highlightedImage:@"logo" target:nil action:nil];

    //LeftView
    UIView* leftView=[[UIView alloc]init];
    leftView.frame=CGRectMake(0, 0, 124, [UIScreen mainScreen].screenH-64);
    UIImage* backImage=[UIImage resizableImageNamed:@"left"];
    UIImageView* imageView=[[UIImageView alloc]initWithImage:backImage];
    imageView.bounds=leftView.bounds;
    imageView.x=0;
    imageView.y=0;
    [leftView addSubview:imageView];
    [self.view addSubview:leftView];
    
    // 2.类别
    TCHomeTopItem *categoryItem = [TCHomeTopItem topItem];
    self.categoryItem.titleLabel.text=@"分类";
    self.categoryItem.subTitleLabel.text=@"详细分类";
    //给按钮添加点击方法
    [categoryItem.iconBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryItem.iconBtn setImage:[UIImage imageNamed:@"icon_category_1"] forState:UIControlStateNormal];
    [categoryItem.iconBtn setImage:[UIImage imageNamed:@"icon_category_1_highlighted"] forState:UIControlStateHighlighted];
    categoryItem.center=CGPointMake(60, 200);
   self.categoryItem=categoryItem;
    
    // 3.地区
    TCHomeTopItem *districtItem = [TCHomeTopItem topItem];
    self.districtItem=districtItem;
    self.districtItem.titleLabel.text=@"城市-区域";
    self.districtItem.subTitleLabel.text=@"街道";
    //给按钮添加点击方法
    [districtItem.iconBtn addTarget:self action:@selector(districtClick:) forControlEvents:UIControlEventTouchUpInside];
    [districtItem.iconBtn setImage:[UIImage imageNamed:@"icon_district"] forState:UIControlStateNormal];
    [districtItem.iconBtn setImage:[UIImage imageNamed:@"icon_district_highlighted"] forState:UIControlStateHighlighted];

    districtItem.center=CGPointMake(60, 350);
 //   self.districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtItem];
    
    // 4.排序
    TCHomeTopItem *sortItem = [TCHomeTopItem topItem];
    self.sortItem=sortItem;
    self.sortItem.titleLabel.text=@"排序方式";
    self.sortItem.subTitleLabel.text=@"默认排序";
    //给按钮添加点击方法
    [sortItem.iconBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    [sortItem.iconBtn setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
    [sortItem.iconBtn setImage:[UIImage imageNamed:@"icon_sort_highlighted"] forState:UIControlStateHighlighted];

    sortItem.center=CGPointMake(60, 500);
 //   self.sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortItem];
    
    //添加分类,地区,排序
    self.navigationItem.leftBarButtonItems = @[logo];
    [leftView addSubview:categoryItem];
    [leftView addSubview:districtItem];
    [leftView addSubview:sortItem];
}
#pragma mark 设置右边
//设置右边 搜索按钮,地图按钮
-(void)setupRightNav{
    //地图ButtonItem
    UIBarButtonItem* map=[UIBarButtonItem itemImage:@"icon_map" highlightedImage:@"icon_map_highlighted" target:self action:@selector(mapClick)];
    map.customView.width=60;
    //搜索Button按钮
    UIBarButtonItem* search=[UIBarButtonItem itemImage:@"icon_search" highlightedImage:@"icon_search_highlighted" target:self action:@selector( searchClick)];
    search.customView.width=60;
    
    self.navigationItem.rightBarButtonItems=@[map,search];
}

#pragma mark- 左(LeftView)右(导航条)Button点击方法
#pragma mark 左部Button点击方法
//分类按钮点击
- (void)categoryClick:(UIButton*)btn{
    [self.categoryPopover presentPopoverFromRect:btn.bounds inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}
//区域按钮点击
-(void)districtClick:(UIButton*)btn{
   
    //districtView.selectedCityName=self.selectedCityName;
 //   self.regionPopover=[[UIPopoverController alloc]initWithContentViewController:districtView];
    [self.regionPopover presentPopoverFromRect:btn.bounds inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
//排序方式点击
-(void)sortClick:(UIButton*)btn{
    [self.sortPopover presentPopoverFromRect:btn.bounds inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark 右部Button点击方法
//搜索按钮点击方法
-(void)searchClick{

    if(self.selectedCityName.length!=0){
    TCSearchViewController* searchViewController=[[TCSearchViewController alloc]initWithCollectionViewLayout:[[TCWaterFlowLayout alloc]init]];
    searchViewController.cityName=self.selectedCityName;
    TCSearchNavigationController* nv=[[TCSearchNavigationController alloc]initWithRootViewController:searchViewController];
    [self presentViewController:nv animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"请选择城市后再搜索" toView:self.view];
    }
}
//地图按钮点击
-(void)mapClick{
    TCMapViewController* mapViewController=[[TCMapViewController alloc]init];
    [self presentViewController:[[TCNavigationController alloc]initWithRootViewController:mapViewController] animated:YES completion:nil];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deal=self.deals[indexPath.row];
    // Configure the cell
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

#pragma mark- 设置awesomeMenu菜单,就是右下角那个很炫的菜单
-(void)setupAwesomeMenu{
    //1.中间的item
    AwesomeMenuItem* startItem=[[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:nil];
    //周边的3个Item
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_collect_highlighted"] highlightedContentImage:[UIImage imageNamed:nil]];
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_share_highlighted"] highlightedContentImage:[UIImage imageNamed:nil]];
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"] highlightedContentImage:[UIImage imageNamed:nil]];
   
    NSArray* items=@[item0,item1,item2];
    //菜单
    AwesomeMenu* menu=[[AwesomeMenu alloc]initWithFrame:CGRectZero startItem:startItem menuItems:items];
      //添加在collectionView上
    [self.view addSubview:menu];
    //添加布局约束
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];

    // 设置菜单的活动范围
    menu.menuWholeAngle =-M_PI_2;
    // 设置开始按钮的位置
    menu.startPoint = CGPointMake(150, 150);
    // 设置代理
    menu.delegate = self;
}

#pragma mark- AwesomeMenuDelegate
-(void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    switch (idx) {
        case 0:{//收藏
            TCNavigationController* navigationVC=[[TCNavigationController alloc] initWithRootViewController:[[TCCollectViewController alloc] init]];
            [self presentViewController:navigationVC animated:YES completion:nil];
            break;
        }
        case 1:{
            TCNavigationController* navigationVC=[[TCNavigationController alloc] initWithRootViewController:[[TCAllShareViewController alloc] init]];
            [self presentViewController:navigationVC animated:YES completion:nil];
            break;
        }
        case 2:{
            TCNavigationController* navigationVC=[[TCNavigationController alloc] initWithRootViewController:[[TCBrowserViewController alloc] init]];
            [self presentViewController:navigationVC animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark- 懒加载
//分类Popover
-(UIPopoverController*)categoryPopover{
    if(!_categoryPopover){
        _categoryPopover=[[UIPopoverController alloc]initWithContentViewController:[[TCCategoryViewController alloc]init]];
    }
    return _categoryPopover;
}
//区域Popover
-(UIPopoverController*)regionPopover{
    if(!_regionPopover){
        _regionPopover=[[UIPopoverController alloc]initWithContentViewController:[[TCDistrictViewController alloc]init]];
    }
    return _regionPopover;
}
//排序Popover
-(UIPopoverController*)sortPopover{
    if(!_sortPopover){
        _sortPopover=[[UIPopoverController alloc]initWithContentViewController:[[TCSortViewController alloc]init]];
    }
    return _sortPopover;
}
//collectionView
-(UICollectionView*)collectionView{
    if(!_collectionView){
        TCWaterFlowLayout* waterFlowLayout=[[TCWaterFlowLayout alloc]init];
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(124, 0, [UIScreen mainScreen].screenW-124,[UIScreen mainScreen].screenH-64 ) collectionViewLayout:waterFlowLayout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        [self.view addSubview:_collectionView];
        self.collectionView.backgroundColor=TCGlobalBg;
    }
    return _collectionView;
    
}
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
        _imageView.userInteractionEnabled = YES;
        [self.collectionView addSubview:_imageView];
        //自动居中
        [_imageView autoCenterInSuperview];
    
    }
    return _imageView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;}

@end
