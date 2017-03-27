//
//  TCDetailViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCDetailViewController.h"
#import "TCDeal.h"
#import "UIImageView+WebCache.h"
#import "TCShareViewController.h"
#import "TCDealTool.h"
#import "MBProgressHUD+MJ.h"
#import <MessageUI/MessageUI.h>
//#import "PhotoManager.h"
@interface TCDetailViewController ()<UIWebViewDelegate>
//webView加载页面
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//小菊花
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//描述
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end

@implementation TCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.activityIndicatorView startAnimating];
    
   //加载详情页面
    NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",ID]]]];
    
    //设置基本信息
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    [self.imageView sd_setImageWithURL:self.deal.s_image_url placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    self.collectBtn.selected=[TCDealTool isCollected:self.deal];
}
#pragma mark 返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//收藏
- (IBAction)collect:(UIButton*)sender {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[TCCollectDealKey] = self.deal;

    
    //已经收藏
    if(sender.selected){
        sender.selected=NO;
        //将本商品移除出数据库
        [TCDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
        info[TCIsCollectKey] = @NO;
        
    }else{
        //将将本商品添加进数据库
        sender.selected=YES;
         [TCDealTool addCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        info[TCIsCollectKey] = @YES;
    }
   
    [[NSNotificationCenter defaultCenter]postNotificationName:TCCollectStateDidChangeNotification object:nil userInfo:info];
    
}
//分享
- (IBAction)share:(id)sender {
    
    TCShareViewController* shareViewController=[[TCShareViewController alloc]init];
    shareViewController.deal=self.deal;
    
    [self presentViewController:shareViewController animated:YES completion:nil];
}



#pragma mark UIWebViewDelegate
//加载完毕
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    // 用来拼接所有的JS
    NSMutableString *js = [NSMutableString string];
    [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
    [js appendString:@"header.parentNode.removeChild(header);"];
    //删除购买
    [js appendString:@"var last =document.getElementsByClassName('last')[0];"];
    [js appendString:@"last.parentNode.removeChild(last);"];
    //删除立即购买
    [js appendString:@"var buynow =document.getElementsByClassName('buy-now')[0];"];
    [js appendString:@"buynow.parentNode.removeChild(buynow);"];
    //删除最后面的那些乱七八糟的
    [js appendString:@"var footer =document.getElementsByClassName('footer')[0];"];
    [js appendString:@"footer.parentNode.removeChild(footer);"];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [self.activityIndicatorView stopAnimating];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%s",__func__);
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"%s",__func__);
}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}

@end
