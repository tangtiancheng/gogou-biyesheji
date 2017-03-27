//
//  TCSortViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCSortViewController.h"
#import "MJExtension.h"
#import "UIView+TC.h"
#import "TCSort.h"
@interface TCSortViewController ()
@property (nonatomic, strong)NSArray* sorts;

@end

@implementation TCSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sorts=[TCSort mj_objectArrayWithFilename:@"sorts.plist"];
    NSUInteger count = self.sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    for (NSUInteger i = 0; i<count; i++) {
        TCSort *sort = self.sorts[i];
        
        UIButton *button = [[UIButton alloc] init];
        button.width = btnW;
        button.height = btnH;
        button.x = btnX;
        button.y = btnStartY + i * (btnH + btnMargin);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:sort.label forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
    }
    
    // 设置控制器在popover中的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
}

- (void)buttonClick:(UIButton *)button
{
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TCSortDidChangeNotification object:nil userInfo:@{TCSelectSort : self.sorts[button.tag]}];
}

@end
