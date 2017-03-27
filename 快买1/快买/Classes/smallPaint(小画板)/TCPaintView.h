//
//  TCPaintView.h
//  TCSmallPaintViewController
//
//  Created by 唐天成 on 16/1/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCPaintView : UIView
//线的宽度
@property(nonatomic,assign)CGFloat lineWidth;
//线的颜色
@property (nonatomic, strong)UIColor* lineColor;
//清屏
- (void)clearScreen;
//撤销
- (void)undo;
//橡皮擦
- (void)eraser;
//当前图片
@property (nonatomic, strong)UIImage* image;

@end
