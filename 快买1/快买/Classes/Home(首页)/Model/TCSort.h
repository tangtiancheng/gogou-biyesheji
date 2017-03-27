//
//  TCSort.h
//  快买
//
//  Created by 唐天成 on 16/1/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSort : NSObject
//排序名称
@property (nonatomic, strong)NSString* label;
//排序值 将值发给服务器
@property(nonatomic,assign)int value;
@end
