//
//  TCDealCell.h
//  快买
//
//  Created by 唐天成 on 16/1/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCDeal,TCDealCell;

@protocol TCDealCellDelegate <NSObject>
@optional
- (void)coverViewDidChange:(TCDealCell *)cell;

@end

@interface TCDealCell : UICollectionViewCell
@property (nonatomic, strong)TCDeal* deal;


@property (nonatomic, weak) id<TCDealCellDelegate> delegate;
@end
