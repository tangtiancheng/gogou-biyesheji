//
//  TCShareMessage.h
//  快买
//
//  Created by 唐天成 on 16/1/19.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCShareMessage : NSObject
//分享的文字
@property (nonatomic, copy)NSString*  textt;
//分享的图片
@property (nonatomic, strong)UIImage* image;
//分享的日期
@property (nonatomic, strong)NSString* date;



@end
