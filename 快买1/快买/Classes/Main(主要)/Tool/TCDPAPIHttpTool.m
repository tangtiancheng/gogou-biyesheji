//
//  TCDPAPIHttpTool.m
//  快买
//
//  Created by 唐天成 on 16/1/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCDPAPIHttpTool.h"

@interface TCDPAPIHttpTool()<DPRequestDelegate>
@property (nonatomic, strong)DPRequest* lastRequest;


@end

static DPAPI* _api;
@implementation TCDPAPIHttpTool
+ (void)initialize
{
    if (self == [TCDPAPIHttpTool class]) {
        _api=[[DPAPI alloc]init];
    }
}

-(void)requestWithURL:(NSString*)url params:(NSMutableDictionary*)params success:(void(^)(id result))success failure:(void(^)(NSError* error))failure{
    DPRequest* lastRequest = [_api requestWithURL:url params:params delegate:self];
//    NSLog(@"123");
   // self.lastRequest.success = success;
   // self.lastRequest.failure = failure;

}
#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
//    NSLog(@"12333");
//    if(request.success){
//        if(result==self.lastRequest){
//        request.success(result);
//        }
//        
//    }
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
//    NSLog(@"12333444");
//    if (request.failure) {
//        if(request==self.lastRequest){
//        request.failure(error);
//        }
//    }
}
@end
