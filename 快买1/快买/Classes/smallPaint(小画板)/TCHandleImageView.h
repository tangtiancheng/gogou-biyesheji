//
//  TCHandleImageView.h
//  TCSmallPaintViewController
//
//  Created by 唐天成 on 16/1/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HMHandleImageViewBlock)(UIImage *image);
@interface TCHandleImageView : UIView
@property (nonatomic, strong)UIImage* image;
@property (nonatomic, copy) HMHandleImageViewBlock block;
@end
