//
//  TCWaterFlowLayout.m
//  快买
//
//  Created by 唐天成 on 16/1/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCWaterFlowLayout.h"

@interface TCWaterFlowLayout()
//这个字典用来存储每一列最大的Y值(每一列的高度)
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
//存放所有的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end

@implementation TCWaterFlowLayout
- (NSMutableDictionary *)maxYDict
{
    if (!_maxYDict) {
        self.maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.columnMargin = 15;
        self.rowMargin = 15;
        self.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        self.columnsCount = 3;
        
        
    }
    return self;
}
/**
 * 返回所有的尺寸
 */
-(CGSize)collectionViewContentSize{
    
    __block NSString* maxColumn=@"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if([maxY floatValue]>[self.maxYDict[maxColumn]floatValue]){
            maxColumn=column;
        }
    }];
 //   NSLog(@"%s   %@",__func__,NSStringFromCGSize(CGSizeMake(0, [self.maxYDict[maxColumn] floatValue]+self.sectionInset.bottom)));
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue]+self.sectionInset.bottom);
}
/**
 *  每次布局之前的准备
 */
-(void)prepareLayout{
    [super prepareLayout];
    //    NSLog(@"%s",__func__);
    // 1.清空最大的Y值
    for (int i = 0; i<self.columnsCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        self.maxYDict[column] = @(self.sectionInset.top);
    }
    
    // 2.计算所有cell的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //   NSLog(@"haha%d",count);
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}

/**
 *  返回indexPath这个位置Item的布局属性
 */
-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //  NSLog(@"%s  %@  %d",__func__,self.maxYDict,indexPath.row);
    //假设最短的那一列的第0列
    __block NSString* minColumn=@"0";
    //找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        
        if([maxY floatValue]<[self.maxYDict[minColumn] floatValue]){
            minColumn=column;
        }
    }];
    // 计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount - 1) * self.columnMargin)/self.columnsCount;
    CGFloat height = 270+(arc4random()%50);
    
    //计算位置
    CGFloat x=self.sectionInset.left+(width+self.columnMargin)*[minColumn intValue];
    CGFloat y=[self.maxYDict[minColumn] floatValue]+self.rowMargin;
    //更新这一列的最大Y值
    self.maxYDict[minColumn]=@(y+height);
    
    //创建属性
    UICollectionViewLayoutAttributes* attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame=CGRectMake(x, y, width, height);
    return attrs;
}
/**
 *  返回rect范围内的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
   // NSLog(@"%s  %d   %@",__func__,self.attrsArray.count,NSStringFromCGRect(rect));
    return self.attrsArray;
}

@end
