//
//  TCCollectViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/18.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCCollectViewController.h"
#import "TCDealCell.h"
#import "TCDealTool.h"
#import "UIBarButtonItem+TC.h"
#import "TCDetailViewController.h"
#import "TCDeal.h"
#import "TCDealTool.h"
@interface TCCollectViewController ()<TCDealCellDelegate>
//所有收藏
@property (nonatomic, strong)NSMutableArray* deals;

//返回
@property (nonatomic, strong) UIBarButtonItem *backItem;
//全选
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
//全不选
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
//删除
@property (nonatomic, strong) UIBarButtonItem *removeItem;
//编辑||完成
@property (nonatomic, strong)UIBarButtonItem* editItem;


@end

@implementation TCCollectViewController

static NSString * const reuseIdentifier = @"Cell";
-(id)init{
    if(self=[super init]){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // cell的大小
        layout.itemSize = CGSizeMake(320, 320);
        layout.sectionInset=UIEdgeInsetsMake(30, 15, 15, 15);
        return [self initWithCollectionViewLayout:layout];

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor=TCGlobalBg;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TCDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.title = @"我的收藏";
    
    //收藏的数据
    [self.deals addObjectsFromArray:[TCDealTool collectDeals]];
    //设置左边导航栏
    self.navigationItem.leftBarButtonItems=@[self.backItem];
    //设置右边导航栏
    self.navigationItem.rightBarButtonItem=self.editItem;
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collectStateChange:) name:TCCollectStateDidChangeNotification object:nil];
}

//返回
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//全选
-(void)selectAll{
    BOOL hasChecking = NO;
   
    for(TCDeal* deal in self.deals){
        deal.checking=YES;
        hasChecking=YES;
    }
    [self.collectionView reloadData];
    // 根据有没有打钩的情况,决定删除按钮是否可用
    self.removeItem.enabled = hasChecking;
}
//全不选
-(void)unselectAll{
   
    for(TCDeal* deal in self.deals){
        deal.checking=NO;
    }
    [self.collectionView reloadData];
    // 根据有没有打钩的情况,决定删除按钮是否可用
    self.removeItem.enabled = NO;

}
//删除
-(void)remove{
     NSMutableArray *tempArray = [NSMutableArray array];
    for(TCDeal* deal in self.deals){
       
        if(deal.checking){
            [tempArray addObject:deal];
            [TCDealTool removeCollectDeal:deal];
        }
    }
    [self.deals removeObjectsInArray:tempArray];
    [self.collectionView reloadData];

}
//编辑按钮点击
-(void)editChange:(UIBarButtonItem*)item{
    if([item.title isEqualToString:@"编辑"]){
        item.title=@"完成";
        self.navigationItem.leftBarButtonItems=@[self.backItem,self.selectAllItem,self.unselectAllItem,self.removeItem];
      //  self.removeItem.enabled = NO;
        for(TCDeal* deal in self.deals){
            deal.editing=YES;
        
        }
        
    }else{
        item.title=@"编辑";
        self.navigationItem.leftBarButtonItems=@[self.backItem];
        for(TCDeal* deal in self.deals){
            deal.editing=NO;
            deal.checking=NO;
        }
    }
    //刷新表格
    [self.collectionView reloadData];
}
- (void)collectStateChange:(NSNotification *)notification
{
        if ([notification.userInfo[TCIsCollectKey] boolValue]) {
            // 收藏成功
            [self.deals insertObject:notification.userInfo[TCCollectDealKey] atIndex:0];
        } else {
            // 取消收藏成功
            [self.deals removeObject:notification.userInfo[TCCollectDealKey]];
        }
    
        [self.collectionView reloadData];
//    [self.deals removeAllObjects];
    
    
}

#pragma mark <TCDealCellDelegate>
-(void)coverViewDidChange:(TCDealCell *)cell{
    BOOL hasChecking = NO;
    for (TCDeal *deal in self.deals) {
        if (deal.isChecking) {
            hasChecking = YES;
            break;
        }
    }
    // 根据有没有打钩的情况,决定删除按钮是否可用
    self.removeItem.enabled = hasChecking;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCDealCell* cel=[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cel.deal=self.deals[indexPath.item];
    cel.delegate=self;
    return cel;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TCDetailViewController *detailVc = [[TCDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}



#pragma mark- 懒加载
-(NSMutableArray*)deals{
    if(!_deals){
        _deals=[NSMutableArray array];
    }
    return _deals;
}

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
       self.backItem =  [UIBarButtonItem itemImage:@"icon_back" highlightedImage:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@" 全选 " style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
        
        _selectAllItem.accessibilityElementsHidden=YES;
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:@" 全不选 " style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}

- (UIBarButtonItem *)removeItem
{
    if (!_removeItem) {
        self.removeItem = [[UIBarButtonItem alloc] initWithTitle:@" 删除 " style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
        _removeItem.enabled=NO;
    }
    return _removeItem;
}
-(UIBarButtonItem*)editItem{
    if(!_editItem){
        self.editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editChange:)];

    }
        return _editItem;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
