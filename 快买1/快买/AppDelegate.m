//
//  AppDelegate.m
//  快买
//
//  Created by 唐天成 on 15/12/28.
//  Copyright © 2015年 唐天成. All rights reserved.
//

#import "AppDelegate.h"
#import "TCNavigationController.h"
#import "TCHomeViewController.h"
#import "TCNewFeatureViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


//#import "PhotoManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ShareSDK registerApp:@"f08a622dc7a4" activePlatforms:@[//@(SSDKPlatformTypeSinaWeibo),
                                                            @(SSDKPlatformTypeWechat),
                                                            @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
                                                                switch (platformType)
                                                                {
                                                                    case SSDKPlatformTypeWechat:
                                                                        [ShareSDKConnector connectWeChat:[WXApi class]];
                                                                        break;
                                                                    case SSDKPlatformTypeQQ:
                                                                        [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                                        break;
//                                                                    case SSDKPlatformTypeSinaWeibo:
//                                                                        [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                                                                        break;
                                                                        
                                                                    default:
                                                                        break;
                                                                }
                                                            } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                                switch (platformType)
                                                                {
//                                                                    case SSDKPlatformTypeSinaWeibo:
//                                                                        //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                                                                        [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                                                                                                  appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                                                                                                redirectUri:@"http://www.sharesdk.cn"
//                                                                                                   authType:SSDKAuthTypeBoth];
//                                                                        break;
                                                                    case SSDKPlatformTypeWechat:
                                                                        [appInfo SSDKSetupWeChatByAppId:@"wx418a73620e99c30b"
                                                                                              appSecret:@"8350ce44f7f3bb13a4e200bcb29a5a21"];
                                                                        break;
                                                                    case SSDKPlatformTypeQQ:
                                                                        [appInfo SSDKSetupQQByAppId:@"1105345628"
                                                                                             appKey:@"hcwTU7XplpPUHeMZ"
                                                                                           authType:SSDKAuthTypeBoth];
                                                                        break;
                                                                    default:
                                                                        break;
                                                                }
                                                            }];

    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController =[[TCNewFeatureViewController alloc]init] ;//[[TCNewFeatureViewController alloc]init];////;
//    [[PhotoManager getInstance] setHengping];
    [self.window makeKeyAndVisible];
    return YES;

}
//-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    if ( [[PhotoManager getInstance] isHengping] ) {
//        NSLog(@"横着的");
//        return UIInterfaceOrientationMaskLandscape;
//    }else{
//        NSLog(@"所有方向");
//        return UIInterfaceOrientationMaskAll ;
//    }
//
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
