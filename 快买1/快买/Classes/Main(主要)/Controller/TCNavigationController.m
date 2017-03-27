//
//  TCNavigationController.m
//  快买
//
//  Created by 唐天成 on 15/12/28.
//  Copyright © 2015年 唐天成. All rights reserved.
//

#import "TCNavigationController.h"

@interface TCNavigationController ()

@end

@implementation TCNavigationController
+(void)initialize{

//    UINavigationBar* navigationBar=[UINavigationBar appearance];
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}

@end
