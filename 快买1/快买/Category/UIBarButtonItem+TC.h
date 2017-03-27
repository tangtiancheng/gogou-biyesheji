//
//  UIBarButtonItem+NJ.h
//  传智WB
//
//  Created by 唐天成 on 15-10-21.
//  Copyright (c) 2015年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TC)
/**
 *  创建图片按钮
 *
 *  @param image            图片按钮默认状态的图片
 *  @param highlightedImage 图片按钮高亮状态的图片
 *  @param action           监听图片按钮点击时间
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)itemImage:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;
@end
