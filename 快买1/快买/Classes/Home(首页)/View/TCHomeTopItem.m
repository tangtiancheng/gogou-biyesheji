//
//  TCHomeTopItem.m
//  快买
//
//  Created by 唐天成 on 15/12/28.
//  Copyright © 2015年 唐天成. All rights reserved.
//

#import "TCHomeTopItem.h"
@interface TCHomeTopItem()

@end

@implementation TCHomeTopItem

+(instancetype)topItem{
    return [[NSBundle mainBundle]loadNibNamed:@"TCHomeTopItem" owner:nil options:nil][0];
}
-(void)awakeFromNib{
    //横竖屏切换时防止拉伸
    self.autoresizingMask=UIViewAutoresizingNone;
}
@end
