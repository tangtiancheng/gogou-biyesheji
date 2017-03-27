//
//  TCAllShareViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/19.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCAllShareViewController.h"
#import "TCShareMessage.h"
#import "TCDealTool.h"
#import "TCShareCell.h"

@interface TCAllShareViewController ()
//分享消息数组
@property (nonatomic, strong)NSArray* shareMessages;
//返回
@property (nonatomic, strong) UIBarButtonItem *backItem;
@end
static NSString* const reuseIdentifier = @"Cell";
@implementation TCAllShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=TCGlobalBg;
     self.title=@"我的所有分享";
    self.tableView.estimatedRowHeight = 30;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //设置左边导航栏
    self.navigationItem.leftBarButtonItems=@[self.backItem];
    self.shareMessages =[TCDealTool shareMessages];
//    NSLog(@"123");
    //注册TCShareCell
    [self.tableView registerNib:[UINib nibWithNibName:@"TCShareCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view from its nib.
}
//返回
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- UITableViewDataSouce
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shareMessages.count;
}

#pragma mark- UITableViewDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCShareCell* cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TCShareMessage* shareMessage=self.shareMessages[indexPath.row];
    cell.shareMessage=shareMessage;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
#pragma mark- 懒加载
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        self.backItem =  [UIBarButtonItem itemImage:@"icon_back" highlightedImage:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}

@end
