//
//  TCHandleImageView.m
//  TCSmallPaintViewController
//
//  Created by 唐天成 on 16/1/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCHandleImageView.h"
@interface TCHandleImageView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIImageView* imageView;

@end

@implementation TCHandleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      //  self.backgroundColor=[UIColor greenColor];
        // 添加UIImageView
        [self addImageView];
        
        // 添加手势
        [self addGestureRecognizers];
    }
    return self;
}
#pragma mark - 添加手势
- (void)addGestureRecognizers
{
    [self addPan];
    [self addLongPress];
    [self addPinch];
    [self addRotation];
}
#pragma mark 拖动
- (void)addPan{
    // 拖动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_imageView addGestureRecognizer:pan];

}
-(void)pan:(UIPanGestureRecognizer*)pan{
    if (UIGestureRecognizerStateChanged == pan.state) {
        // 手势识别发生的视图
        UIImageView *imageView = pan.view;
        
        CGPoint translation = [pan translationInView:imageView];
        imageView.transform = CGAffineTransformTranslate(imageView.transform, translation.x, translation.y);
        
        // 每次形变之后，将当前的位移作为初始位移！！！
        [pan setTranslation:CGPointZero inView:imageView];
    }

}

#pragma mark 长按
- (void)addLongPress{
    // 1.长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.delegate=self;
    [_imageView addGestureRecognizer:longPress];

}
- (void)longPress:(UILongPressGestureRecognizer *)longPrss
{
    if (longPrss.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _imageView.alpha = 0.3;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 animations:^{
                _imageView.alpha = 1;
            } completion:^(BOOL finished) {
                
                // 1.截屏
                //开启上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
                // 获取上下文
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                // 渲染控制器view的图层到上下文
                // 图层只能用渲染不能用draw
                [self.layer renderInContext:ctx];
                // 获取截屏图片
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                // 关闭上下文
                UIGraphicsEndImageContext();
                // 2.把图片传给控制器
                _block(newImage);
                
                // 3.把自己移除父控件
                [self removeFromSuperview];
                
            }];
            
        }];
        
    }
}

#pragma mark - 捏合
- (void)addPinch
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    // 设置代理的原因：想要同时支持多个手势
    pinch.delegate = self;
    [_imageView addGestureRecognizer:pinch];
    
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    _imageView.transform = CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);
    
    // 复位
    pinch.scale = 1;
}

#pragma mark - 旋转
- (void)addRotation
{
    // rotation
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [_imageView addGestureRecognizer:rotation];
}

- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    
    //    _imagView.transform = CGAffineTransformMakeRotation(rotation.rotation);
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, rotation.rotation);
    
    // 复位
    rotation.rotation = 0;
}

#pragma mark 传给一个图片就展示到UIImageView上
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    _imageView.image = image;
}

#pragma mark 添加图片
- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    imageView.userInteractionEnabled = YES;
    
    _imageView = imageView;
    [self addSubview:imageView];
}

// Simultaneous:同时
// 默认是不支持多个手势
// 当你使用一个手势的时候就会调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
