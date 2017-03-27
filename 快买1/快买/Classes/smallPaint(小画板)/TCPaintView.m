//
//  TCPaintView.m
//  TCSmallPaintViewController
//
//  Created by 唐天成 on 16/1/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCPaintView.h"
#import "TCPaintPath.h"
@interface TCPaintView()
//当前的路径
@property(nonatomic,strong)UIBezierPath* currentpath;
//路径数组
@property (nonatomic, strong)NSMutableArray* paths;

@end

@implementation TCPaintView
//刚开始touch,创建路径
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    //创建贝塞尔路径
    TCPaintPath* paintPath=[TCPaintPath paintPathWithLineWidth:self.lineWidth color:self.lineColor startPoint:point];
    self.currentpath=paintPath;
    //将路劲添加进数组
    [self.paths addObject:self.currentpath];
    
}
//挪动手指
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    [self.currentpath addLineToPoint:point];
    [self setNeedsDisplay];
}

//清屏
- (void)clearScreen{
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}
//撤销
- (void)undo{
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}
//橡皮擦
- (void)eraser{
    self.lineWidth=15;
    self.lineColor=[UIColor whiteColor];
}
//重写image的set方法
-(void)setImage:(UIImage *)image{
    _image=image;
    [self.paths addObject:_image];
    [self setNeedsDisplay];
}
// 把之前的全部清空 重新绘制
- (void)drawRect:(CGRect)rect
{
    if (!self.paths.count) return;
    
    // 遍历所有的路径绘制
    for (TCPaintPath *path in self.paths) {
        if ([path isKindOfClass:[UIImage class]]) { // UIImage
            UIImage *image = (UIImage *)path;
            [image drawAtPoint:CGPointZero];
        }else{ // HMPaintPath
            
            [path.color set];
            [path stroke];
        }
    }
}


-(NSMutableArray*)paths{
    if(!_paths){
        _paths=[NSMutableArray array];
    }
    return _paths;
}
@end
