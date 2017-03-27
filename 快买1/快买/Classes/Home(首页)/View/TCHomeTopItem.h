//
//  TCHomeTopItem.h
//  快买
//
//  Created by 唐天成 on 15/12/28.
//  Copyright © 2015年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCHomeTopItem : UIView
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

+(instancetype)topItem;
@end
