//
//  TCPaintPath.h
//  TCSmallPaintViewController
//
//  Created by 唐天成 on 16/1/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCPaintPath : UIBezierPath
//建立初始化贝塞尔路径
+(instancetype)paintPathWithLineWidth:(CGFloat)width color:(UIColor*)color startPoint:(CGPoint)point;
//路径的颜色
@property (nonatomic, strong)UIColor* color;

@end
