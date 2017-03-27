//
//  TCAnnotation.m
//  快买
//
//  Created by 唐天成 on 16/1/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCAnnotation.h"

@implementation TCAnnotation
-(BOOL)isEqual:(TCAnnotation*)object{
    return [self.title isEqual:object.title];
}
@end
