//
//  TCShareViewController.m
//  快买
//
//  Created by 唐天成 on 16/1/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCShareViewController.h"
#import <Social/Social.h>
#import "TCDeal.h"
#import "MBProgressHUD+MJ.h"
#import "TCSmallPaintViewController.h"
#import "UIImageView+WebCache.h"
#import "TCShareMessage.h"
#import "TCDealTool.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "UIImage+TC.h"

@interface TCShareViewController ()<UIImagePickerControllerDelegate,UITextFieldDelegate>
//分享的图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//分享的文章textField
@property (weak, nonatomic) IBOutlet UITextField *textField;

//分享的数据模型
@property (nonatomic, strong)TCShareMessage* shareMessage;

@end

@implementation TCShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //点击图片
    UITapGestureRecognizer* tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPicture:)];
    //添加点击事件
    [self.imageView addGestureRecognizer:tapGR];
    //默认图片
    [self.imageView sd_setImageWithURL:self.deal.s_image_url placeholderImage:[UIImage imageNamed:@"rankList_bottom_icon_middle"]];
   
}
//返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//选择图片
-(void)selectPicture:(UITapGestureRecognizer*)recognizer{
//    [[PhotoManager getInstance] setShuping];
//    UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"xuanxiang" message:@"xingxi" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"nima",nil];
//    [alertView show];
    
    UIAlertController* alertController=[UIAlertController alertControllerWithTitle:@"选择相册或拍照" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* alertAction=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //1.需要调用苹果的照片选择器
        UIImagePickerController* picker=[[UIImagePickerController alloc]init];
        //2.需要知道从哪里来的照片
        /**
         UIImagePickerControllerSourceTypePhotoLibrary      照片库(相机拍摄、手机同步的所有照片)
         UIImagePickerControllerSourceTypeCamera,           相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum  相机拍摄，用户保存的
         */
        picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        picker.delegate=self;
        //3.显示
            [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction* alertAction1=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //1.需要调用苹果的照片选择器
        UIImagePickerController* picker=[[UIImagePickerController alloc]init];
        //2.需要知道从哪里来的照片
        /**
         UIImagePickerControllerSourceTypePhotoLibrary      照片库(相机拍摄、手机同步的所有照片)
         UIImagePickerControllerSourceTypeCamera,           相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum  相机拍摄，用户保存的
         */
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        
        picker.delegate=self;
        //3.显示
            [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction* alertAction2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:alertAction];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];

    
 
    
}
//进入小画板
- (IBAction)joinSmallPaint:(id)sender {
    TCSmallPaintViewController* smallPaintVC=[[TCSmallPaintViewController alloc]init];
    smallPaintVC.block=^(UIImage* image){
        self.imageView.image=image;
    };
    [self presentViewController:smallPaintVC animated:YES completion:nil];
}

//分享
- (IBAction)share:(id)sender {
    //1、创建分享参数
    NSArray* imageArray = @[self.imageView.image];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"网址:%@ %@",self.deal.deal_h5_url,self.textField.text]
                                         images:imageArray
                                            url:[NSURL URLWithString:self.deal.deal_h5_url]
                                          title:self.deal.title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        
        [ShareSDK showShareActionSheet:sender //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               NSLog(@"hahah%@    %@",contentEntity.cid,contentEntity.text);
                               NSLog(@"%@",contentEntity);
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               //分享的消息
                               TCShareMessage* shareMessage=[[TCShareMessage alloc]init];
                               NSDate* date=[NSDate date];
                               NSDateFormatter* dateFormate=[[NSDateFormatter alloc]init];
                               dateFormate.dateFormat=@"yyyy年MM月dd日HH时mm分ss秒";
                               NSString* dateString=[dateFormate stringFromDate:date];
                               NSString* platType=nil;
                               switch (platformType) {
                                   case SSDKPlatformTypeSinaWeibo:
                                       platType=@"新浪微博";
                                       break;
                                   case SSDKPlatformSubTypeQZone:
                                       platType=@"QQ空间";
                                       break;

                                   case SSDKPlatformSubTypeWechatSession:
                                       platType=@"微信好友";
                                       break;

                                   case SSDKPlatformSubTypeWechatTimeline:
                                       platType=@"微信朋友圈";
                                       break;
                                   case SSDKPlatformSubTypeQQFriend:
                                       platType=@"QQ好友";
                                       break;
                                   case SSDKPlatformSubTypeWechatFav:
                                       platType=@"微信收藏";
                                       break;
                                   case SSDKPlatformTypeQQ:
                                       platType=@"QQ平台";
                                       break;

                                   default:
                                       break;
                               }
                               shareMessage.textt=[NSString stringWithFormat:@"%@ 分享与%@平台",contentEntity.text,platType];
                               shareMessage.image=self.imageView.image;
                               shareMessage.date=dateString;
                               //添加一个分享进数据库
                               [TCDealTool addShareMessage:shareMessage];

                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                              
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }

    
    //    //1.判断服务是否可用
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]){
//        NSLog(@"分享服务可用");
//    }
//    //创建分享控制器
//    SLComposeViewController* composeVC=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
//    
//    //设置默认数据
//    NSString* text=[NSString stringWithFormat:@"网址:%@ %@",self.deal.deal_h5_url,self.textField.text];
//    [composeVC setInitialText:text];
//    [composeVC addImage:self.imageView.image];
//    
//    //3.弹出分享控制器
//    [self presentViewController:composeVC animated:YES completion:nil];
//    //4.监听分享状态
//    composeVC.completionHandler=^(SLComposeViewControllerResult result){
//        if (result == SLComposeViewControllerResultCancelled) {
//            [MBProgressHUD showError:@"取消发送" toView:self.view];
//        }else
//        {
//            
//            [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
//            //分享的消息
//            TCShareMessage* shareMessage=[[TCShareMessage alloc]init];
//            NSDate* date=[NSDate date];
//            NSDateFormatter* dateFormate=[[NSDateFormatter alloc]init];
//            dateFormate.dateFormat=@"yyyy年MM月dd日HH时mm分ss秒";
//            NSString* dateString=[dateFormate stringFromDate:date];
//            
//            shareMessage.textt=text;
//            shareMessage.image=self.imageView.image;
//            shareMessage.date=dateString;
//            //添加一个分享进数据库
//            [TCDealTool addShareMessage:shareMessage];
//        }
//    };
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    [[PhotoManager getInstance] setHengping];
    UIImage* image=info[UIImagePickerControllerOriginalImage];
    UIImage* imageNew=[UIImage thumbnailWithImageWithoutScale:image size:CGSizeMake(360, 360)];
    self.imageView.image=imageNew;
//    NSLog(@"%ld    %ld       %ld     %ld",UIImageJPEGRepresentation(image, 1.0).length/1024,UIImagePNGRepresentation(image).length/1024,UIImageJPEGRepresentation(imageNew, 1.0).length/1024,UIImagePNGRepresentation(imageNew).length/1024);
//
//        NSData *imageData = nil;
//        for(float compression = 1.0; compression >= 0.0; compression -= .1) {
//    //        NSLog(@"%f",compression);
//            imageData = UIImageJPEGRepresentation(image, compression);
//            NSInteger imageLength = imageData.length;
//            NSLog(@"%f  %ld",compression ,imageLength/1024);
//            if(imageLength/1024 <= 250) {
//                break;
//            }
//        }
//        NSLog(@"%ld",imageData.length/1024);
//    NSData* d=[NSData dataWithData:imageData];
//        UIImage* imageNew=[UIImage imageWithData:d];
////        NSData* data1=UIImagePNGRepresentation(image);
////        NSLog(@"%ld",data1.length/1024);
////        self.imageView.image=imageNew;
//    
//    //让imageView=选中得图片
//    self.imageView.image=imageNew;
//    NSData* data1=UIImageJPEGRepresentation(imageNew,1.0);
//    NSData* data11=UIImageJPEGRepresentation(self.imageView.image,1.0);
//    NSLog(@"JPEG %ld   %ld      PNG %ld  %ld",data1.length/1024,data11.length/1024,UIImagePNGRepresentation(imageNew).length/1024,UIImagePNGRepresentation(self.imageView.image).length/1024);
    //一旦实现此方法，就需要自己关闭照片选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [[PhotoManager getInstance] setHengping];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    NSLog(@"取消");
}
#pragma mark UITextFieldDelgate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}

////支持横屏
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}


@end
