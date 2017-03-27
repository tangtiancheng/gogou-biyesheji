//
//  UIBarButtonItem+NJ.m
//  传智WB
//
//  Created by 唐天成 on 15-10-21.
//  Copyright (c) 2015年 唐天成. All rights reserved.
//

#import "UIBarButtonItem+TC.h"

@implementation UIBarButtonItem (TC)

+ (UIBarButtonItem *)itemImage:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action{
//创建一个UIButton
    UIButton *btn = [[UIButton alloc] init];
// 设置默认状态图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
// 设置高亮状态图片
    [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
// 设置size
    btn.size = btn.currentImage.size;
// 监听点击事件
[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
// 生成UIBarButtonItem
return [[UIBarButtonItem alloc] initWithCustomView:btn];

}
@end
