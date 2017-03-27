//
//  TCDPAPIHttpTool.h
//  快买
//
//  Created by 唐天成 on 16/1/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAPI.h"
@interface TCDPAPIHttpTool : NSObject
-(void)requestWithURL:(NSString*)url params:(NSMutableDictionary*)params success:(void(^)(id json))success failure:(void(^)(NSError* error))failure;
@end
