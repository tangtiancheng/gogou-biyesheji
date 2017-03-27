//
//  TCDistrictViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCDistrictViewController.h"
#import "TCCityViewController.h"
#import "TCNavigationController.h"
#import "TCCity.h"
#import "TCRegion.h"
#import "MJExtension.h"
@interface TCDistrictViewController ()<UITableViewDataSource,UITableViewDelegate>

//当前城市
@property (nonatomic,strong)TCCity* city;
//当前区域
@property (nonatomic, strong)TCRegion* region;


//区域tableiew
@property (weak, nonatomic) IBOutlet UITableView *regionTableView;
//街道tableView
@property (weak, nonatomic) IBOutlet UITableView *subRegionTableView;

@property (weak, nonatomic) IBOutlet UIButton *selectedCityBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectCityLabel;

@end

@implementation TCDistrictViewController
//点击选择城市
- (IBAction)selectCityClick:(id)sender {
    TCNavigationController* navigationViewController=[[TCNavigationController alloc]initWithRootViewController:[[TCCityViewController alloc]init]];
    //修改控制器modal的方式.覆盖当前控制器
    navigationViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationViewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置popverController的尺寸
    self.preferredContentSize=CGSizeMake(380, 382);
    
    NSArray* cities=[TCCity mj_objectArrayWithFilename:@"cities.plist"];
#warning 以下是监听通知
    //选择城市发生变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityDidChange:) name:TCCityDidChangeNotification object:nil];
}
//选择城市发生变化
-(void)cityDidChange:(NSNotification*)notification{
    NSString* cityName=notification.userInfo[TCSelectCityName];
    //将当前区域=nil 这样subRegionTableView也会清空
    self.region=nil;
    self.selectCityLabel.text=[NSString stringWithFormat:@"%@",cityName];
    NSArray* cities=[TCCity mj_objectArrayWithFilename:@"cities.plist"];
//    NSLog(@"%d",cities.count);
    for(TCCity* city in cities){
        if([city.name isEqualToString: cityName]){
            self.city=city;
            break;
        }
    }
    
    [self.regionTableView reloadData];
    [self.subRegionTableView reloadData];
}


#pragma mark UITableViewDataSource     UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==_regionTableView){
//        NSLog(@"self.city.regions.count:%d",self.city.regions.count);
        //将区域个数返回
        return self.city.regions.count;
    }else{
//        NSLog(@"self.region.subregions.count:%d",self.region.subregions.count);
       return self.region.subregions.count;
        
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString* identifier=@"Cell";
    UITableViewCell* cel=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(tableView==_regionTableView){
        if(cel==nil){
            cel=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        TCRegion* region=self.city.regions[indexPath.row];
       
        cel.textLabel.text=region.name;
        
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        cel.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        cel.selectedBackgroundView = selectedBg;
        
        if(region.subregions>0){
            cel.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cel.accessoryType=UITableViewCellAccessoryNone;
        }
    }else{
        if(cel==nil){
            cel=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_rightpart"];
        cel.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_right_selected"];
        cel.selectedBackgroundView = selectedBg;
        
        cel.textLabel.text=self.region.subregions[indexPath.row];
    }
    return cel;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果点击的是区
    if(tableView==self.regionTableView){
        self.region=self.city.regions[indexPath.row];
        if(self.region.subregions.count==0){
            //发出通知
            [[NSNotificationCenter defaultCenter]postNotificationName:TCRegionDidChangeNotification object:nil userInfo:@{TCSelectRegionName:self.region.name}];;
        }
        [self.subRegionTableView reloadData];
    }else{//如果点击的是街道
        //发出通知
        [[NSNotificationCenter defaultCenter]postNotificationName:TCRegionDidChangeNotification object:nil userInfo:@{TCSelectRegionName:self.region.name,TCSelectSubregionName:self.region.subregions[indexPath.row]}];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
