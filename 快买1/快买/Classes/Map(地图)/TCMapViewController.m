//
//  TCMapViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/20.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCMapViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "UIBarButtonItem+TC.h"
#import "TCHomeTopItem.h"
#import "TCCategoryViewController.h"
#import "MBProgressHUD+MJ.h"
#import "TCDeal.h"
#import "MJExtension.h"
#import "TCCategory.h"
#import "TCBusiness.h"
#import "TCAnnotation.h"
#import "UIBarButtonItem+TC.h"


@interface TCMapViewController ()<MKMapViewDelegate,DPRequestDelegate>

/** 分类item */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** 分类popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;
//分类名
@property(nonatomic,strong)NSString* selectedCategoryName;
//城市名
@property (nonatomic, copy)NSString* cityName;

@property (weak, nonatomic) IBOutlet MKMapView *mapVIew;
@property (nonatomic, strong)CLLocationManager* mgr;
@property (nonatomic, strong)DPRequest* lastRequest;
//地理反地理编码
@property (nonatomic, strong) CLGeocoder *coder;

@end

@implementation TCMapViewController
- (CLGeocoder *)coder
{
    if (!_coder) {
        self.coder = [[CLGeocoder alloc] init];
    }
    return _coder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //征求用户的同意
    self.mgr=[[CLLocationManager alloc]init];
    //前台:假设用户同意定位
    [self.mgr requestWhenInUseAuthorization];
    //设置地图的代理(监听地图挪动;监听用户的位置)
    self.mapVIew.delegate=self;
    self.mapVIew.rotateEnabled=NO;
    //设置地图的其他属性(地图的类型;是否可以旋转)
    self.mapVIew.userTrackingMode=MKUserTrackingModeFollow;
    // 标题
    self.title = @"快买地图";
    UIBarButtonItem* backItem=[UIBarButtonItem itemImage:@"icon_back" highlightedImage:@"icon_back_highlighted" target:self action:@selector(back)];
    // 设置左上角的分类菜单
    TCHomeTopItem *categoryTopItem = [TCHomeTopItem topItem];
    
    [categoryTopItem.iconBtn addTarget:self action:@selector(categoryClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    // 监听分类改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidChange:) name:TCCategoryDidChangeNotification object:nil];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)categoryClick
{    // 显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[TCCategoryViewController alloc] init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)categoryDidChange:(NSNotification *)notification
{
    NSDictionary* userInfo=notification.userInfo;
    
    TCHomeTopItem* topItem=self.categoryItem.customView;
    topItem.titleLabel.text=userInfo[TCSelectCategoryName];
    topItem.subTitleLabel.text=userInfo[TCSelectSubCategoryName];
    
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
    //关闭Popover
    [self.categoryPopover dismissPopoverAnimated:YES];
//    NSLog(@"%d",self.mapVIew.annotations.count);
    //删除之前的的所有大头针
    [self.mapVIew removeAnnotations:self.mapVIew.annotations];
    
    //发送请求
    
    [self mapView:self.mapVIew regionDidChangeAnimated:YES];
}
#pragma mark - MKMapViewDelegate
//定位失败
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%@",error);
}
#pragma mark --- MKMapViewDelegate
//已经定位到用户的位置的触发方法
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //获取用户的位置
//    NSLog(@"latitude:%f  longitude:%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLLocationCoordinate2D center=userLocation.location.coordinate;
    MKCoordinateSpan span=MKCoordinateSpanMake(0.25,0.25);
    MKCoordinateRegion region=MKCoordinateRegionMake(center, span);
    
//    [self.mapVIew setRegion:region animated:NO];
    //反地理编码
    [self.coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error||placemarks.count==0)return;
        CLPlacemark* pm=[placemarks firstObject];
        
        NSString* cityName=pm.locality?pm.locality:pm.addressDictionary[@"City"];
//        NSLog(@"haha%@   %@",pm.locality,pm.addressDictionary);
        self.cityName=cityName;
        if([[cityName substringFromIndex:cityName.length-1] isEqualToString:@"市"]){
            
            self.cityName = [cityName substringToIndex:cityName.length - 1];

        }
        // 第一次发送请求给服务器
        [self mapView:self.mapVIew regionDidChangeAnimated:YES];

    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(self.cityName == nil)  return;
    //发送请求给服务器
    DPAPI* api=[[DPAPI alloc]init];
    NSMutableDictionary* params=[NSMutableDictionary dictionary];
    //城市
    params[@"city"]=self.cityName;
    //分类
    if(self.selectedCategoryName){
        params[@"category"]=self.selectedCategoryName;
    }
    //经纬度
    params[@"latitude"]=@(mapView.region.center.latitude);
    params[@"longitude"]=@(mapView.region.center.longitude);
    //搜索半径
    params[@"radius"]=@5000;
//    NSLog(@"%@  %@  %@  %@",params[@"city"],params[@"category"],params[@"latitude"],params[@"longitude"]);
    self.lastRequest=[api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // 返回nil,意味着交给系统处理
    if (![annotation isKindOfClass:[TCAnnotation class]]){
        return nil;
    }
    // 创建大头针控件
    static NSString *ID = @"deal";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    
    // 设置模型(位置\标题\子标题)
    annoView.annotation = annotation;
    TCAnnotation* annotation1=(TCAnnotation*)annotation;
    // 设置图片
    annoView.image = [UIImage imageNamed:annotation1.icon];
    
    return annoView;
}

#pragma mark - 请求代理
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request != self.lastRequest) return;
    [MBProgressHUD showError:@"网络不稳定,请稍后重新尝试" toView:self.view];
    NSLog(@"请求失败 - %@", error);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return;
    
    NSArray *deals = [TCDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]];
//    NSLog(@"%d",deals.count);
    for (TCDeal *deal in deals) {
        
        // 获得团购所属的类型
        //分类数组
        NSArray* categories=[TCCategory mj_objectArrayWithFilename:@"categories.plist"];
        TCCategory* category;
       //取该团购类型的第一个
        NSString* cname=[deal.categories firstObject];
        //找到该deal属于哪种分类类型
        for(TCCategory* c in categories){
            if([cname isEqualToString:c.name]){
                category=c;
                break;
            }
            if([c.subcategories containsObject:cname]){
                category=c;
                break;
            }
        }
        for (TCBusiness *business in deal.businesses) {
//            NSLog(@"%@  %@  %@  %f  %f",business.name,deal.title,category.map_icon,business.latitude,business.longitude);
            TCAnnotation* annotation=[[TCAnnotation alloc]init];
            annotation.title=business.name;
            annotation.subtitle=deal.title;
            annotation.icon=category.map_icon;
            annotation.coordinate=CLLocationCoordinate2DMake(business.latitude, business.longitude);
            if([self.mapVIew.annotations containsObject:annotation]){ break;}
            [self.mapVIew addAnnotation:annotation];
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
