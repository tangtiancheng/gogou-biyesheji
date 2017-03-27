//
//  UIImage+IWAdapter6Or7.m
//  传智WB
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 唐天成. All rights reserved.
//

#import "UIImage+TC.h"

@implementation UIImage (TC)
+(instancetype)resizableImageNamed:(NSString*)name{
    UIImage *image = [UIImage imageNamed:name];
    CGFloat left = image.size.width * 0.5;
    CGFloat top = image.size.height * 0.5;
    CGFloat bottom=image.size.height * 0.5;
    CGFloat right=image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}
+ (instancetype)resizableImageNamed:(NSString *)name left:(CGFloat)leftRatio top:(CGFloat)topRatio botton:(CGFloat)bottomRatio right:(CGFloat)rightRatio
{
    UIImage *image = [UIImage imageNamed:name];
    CGFloat left = image.size.width * leftRatio;
    CGFloat top = image.size.height * topRatio;
    CGFloat bottom=image.size.height * bottomRatio;
     CGFloat right=image.size.height * rightRatio;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image)
        
    {
        
        newimage = nil;
        
    } else {
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height)
            
        {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        } else {
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}
@end
