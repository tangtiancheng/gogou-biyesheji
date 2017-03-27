//
//  NSString+NJ.m
//  传智WB
//
//  Created by tarena on 15/10/21.
//  Copyright (c) 2015年 唐天成. All rights reserved.
//

#import "NSString+TC.h"

@implementation NSString (TC)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}
@end
