//
//  UIImage+IWAdapter6Or7.h
//  传智WB
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TC)
@property(nonatomic,strong)NSString* namee;

+(instancetype)resizableImageNamed:(NSString*)name;
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
