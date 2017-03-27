//
//  TCSmallPaintViewController.h
//  TCSmallPaintViewController
//
//  Created by 唐天成 on 16/1/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TCSmallPaintViewControllerBlock)(UIImage *image);

@interface TCSmallPaintViewController : UIViewController
@property (nonatomic, copy) TCSmallPaintViewControllerBlock block;
@end
