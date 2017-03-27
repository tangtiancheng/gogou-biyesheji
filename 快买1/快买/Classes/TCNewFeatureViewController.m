//
//  TCNewFeatureViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCNewFeatureViewController.h"
#import "TCNavigationController.h"
#import "TCHomeViewController.h"
//当前新特性页面个数
#define TCNewFeatureImageCount 4
@interface TCNewFeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIPageControl* pageControl;
@property (nonatomic, strong)UIButton* startButton;


//实例时钟
@property(nonatomic,strong)NSTimer* timer;

@end


@implementation TCNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加scrollerView
    [self setupScrollerView];
    // 2.添加PageControl
    [self setupPageControl];

    // Do any additional setup after loading the view.
}
/**
 *  添加PageControl
 */
- (void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.backgroundColor=[UIColor purpleColor];
    pageControl.centerX = self.view.width * 0.5;
    pageControl.y = self.view.height - 40;
    pageControl.numberOfPages = TCNewFeatureImageCount;
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:pageControl];
    self.pageControl  = pageControl;
}
/**
 *  添加scrollerView
 */
- (void)setupScrollerView
{
    UIScrollView* scrollerView=[[UIScrollView alloc]init];
    scrollerView.frame=self.view.bounds;
    scrollerView.delegate=self;
    [self.view addSubview:scrollerView];
    //添加图片
    CGFloat width=scrollerView.width;
    CGFloat height=scrollerView.height;
    for(int i=0;i<TCNewFeatureImageCount;i++){
        // 1.拼接图片名称
        NSString *imageName = [NSString stringWithFormat:@"guide0%d", i+ 1];
        UIImage *image = [UIImage imageNamed:imageName];
        // 2.创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode=UIViewContentModeCenter;
        imageView.backgroundColor=[UIColor colorWithRed:251/255.0 green:175/255.0 blue:53/255.0 alpha:1.0];
        // 3.设置frame
        imageView.width = width;
        imageView.height = height;
        imageView.y = 0;
        imageView.x = i * width;
        // 4.添加UIImageView到scrollerView
        [scrollerView addSubview:imageView];
        // 5.拿到最后一个UIImageView添加按钮
        //        scrollerView.subviews.lastObject
        if (i == (TCNewFeatureImageCount - 1)) {
            imageView.userInteractionEnabled=YES;
            imageView.contentMode=UIViewContentModeScaleToFill;

            // 1.添加进入快买按钮
            [self setupStartButton:imageView];
        }
    }
    // 3.设置scrollerView的相关属性
    scrollerView.contentSize = CGSizeMake(TCNewFeatureImageCount * width, height);
    scrollerView.pagingEnabled = YES;
    scrollerView.showsHorizontalScrollIndicator = NO;
    // 取消弹簧效果
    scrollerView.bounces = NO;
}
/**
 *  添加进入快买按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 0.让父控件可以和用户交互
    imageView.userInteractionEnabled = YES;
    
    // 1.创建按钮
    self.startButton = [[UIButton alloc] init];
    [imageView addSubview:self.startButton];
    
    // 2.设置背景图片
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button"] forState:UIControlStateNormal];
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    // 3.设置文字
    [self.startButton setTitle:@"点击进入快买" forState:UIControlStateNormal];
   
    // 4.设置frame
    self.startButton.size = CGSizeMake(300, 100);
    self.startButton.centerX = self.view.width * 0.5;
    self.startButton.centerY = self.view.height * 0.8;
    // 5.监听按钮点击事件
    [self.startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}
//点击进入快买
- (void)start
{
    // 跳转到TabBarController
    UIApplication *app = [UIApplication sharedApplication];
    
    UIWindow *window = app.keyWindow;
    
    // 显示状态栏
    //   app.statusBarHidden = NO;
    
    window.rootViewController = [[TCNavigationController alloc] initWithRootViewController:[[TCHomeViewController alloc] init]];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取已经滚动的比例
    int page =round( scrollView.contentOffset.x / self.view.width);
    // 修改pageControl的页码
    self.pageControl.currentPage = page;
    if(page==TCNewFeatureImageCount-1){
        self.timer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startSnow) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
//屏幕刷新事件

-(void)startSnow{
    UIImage *image = [UIImage imageNamed:@"雪花"];
    UIImageView* snowImageView=[[UIImageView alloc]initWithImage:image];
    [snowImageView.layer setValue:@(0.5) forKeyPath:@"transform.scale"];
    [self.view addSubview:snowImageView];
    
  
    //随机产生雪花的初始位置
    snowImageView.centerX=arc4random_uniform(self.view.bounds.size.width);
    snowImageView.centerY=-snowImageView.bounds.size.height;
    
    [UIView animateWithDuration:6.0f animations:^{
        
        //位置
        CGFloat endX = arc4random_uniform(self.view.bounds.size.width);
        CGFloat endY = self.view.bounds.size.height + snowImageView.bounds.size.height;
        
        snowImageView.center = CGPointMake(endX, endY);
        
        //变小
        [snowImageView.layer setValue:@(0.1) forKeyPath:@"transform.scale"];
        //变浅
        [snowImageView.layer setValue:@(0.1) forKey:@"opacity"];
       
    } completion:^(BOOL finished) {
        //从父视图中移除
        [snowImageView removeFromSuperview];
    }];
}
-(void)dealloc{
    
}


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end
