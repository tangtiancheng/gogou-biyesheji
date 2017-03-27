//
//  TCCategoryViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCCategoryViewController.h"
#import "MJExtension.h"
#import "TCCategory.h"
@interface TCCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTbaleView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (nonatomic, strong)NSArray* categories;
@property (nonatomic, strong)TCCategory* selectedCategoary;

@end

@implementation TCCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categories =[TCCategory mj_objectArrayWithFilename:@"categories.plist"];
    //设置popverController的尺寸
    self.preferredContentSize=CGSizeMake(380, 382);
}
#pragma mark TableViewDataSource   TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==self.mainTbaleView){
        return self.categories.count;
    }else{
        return self.selectedCategoary.subcategories.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier=@"Cell";
     UITableViewCell* cel=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(tableView==_mainTbaleView){
            if(cel==nil){
                cel=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            }

        self.selectedCategoary=self.categories[indexPath.row];
        cel.textLabel.text=self.selectedCategoary.name;
        cel.imageView.image=[UIImage imageNamed: self.selectedCategoary.icon];
        cel.imageView.highlightedImage=[UIImage imageNamed:self.selectedCategoary.highlighted_icon];
            UIImageView *bg = [[UIImageView alloc] init];
            bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
            cel.backgroundView = bg;
            
            UIImageView *selectedBg = [[UIImageView alloc] init];
            selectedBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
            cel.selectedBackgroundView = selectedBg;

            if(self.selectedCategoary.subcategories>0){
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

        cel.textLabel.text=self.selectedCategoary.subcategories[indexPath.row];
    }
    return cel;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==_mainTbaleView){
        self.selectedCategoary=self.categories[indexPath.row];
        //如果没有子分类  发出通知
        if(self.selectedCategoary.subcategories.count==0){
            [[NSNotificationCenter defaultCenter]postNotificationName:TCCategoryDidChangeNotification object:nil userInfo:@{TCSelectCategoryName:self.selectedCategoary.name}];
        }
        [self.subTableView reloadData];
    }else{
        //发出通知
        [[NSNotificationCenter defaultCenter]postNotificationName:TCCategoryDidChangeNotification object:nil userInfo:@{TCSelectCategoryName:self.selectedCategoary.name, TCSelectSubCategoryName:self.selectedCategoary.subcategories[indexPath.row]}];
    }
}
@end
