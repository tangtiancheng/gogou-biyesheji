//
//  TCSmallPaintViewController.m
//  TCSmallPaintViewController
//
//  Created by 唐天成 on 16/1/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCSmallPaintViewController.h"
#import "TCPaintView.h"
#import "TCHandleImageView.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+TC.h"
@interface TCSmallPaintViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *leftView;


//线宽slider
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
//红颜色slider
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
//绿颜色slider
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
//蓝颜色slider
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@property (weak, nonatomic) IBOutlet TCPaintView *paintView;

@end

@implementation TCSmallPaintViewController
#pragma mark - 返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 保存
- (IBAction)save:(id)sender {
    // 把画板截屏
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(_paintView.bounds.size, NO, 0.0);
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 把画板上的内容渲染到上下文
    [_paintView.layer renderInContext:ctx];
    
    // 获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    // 保存到用户的相册里面
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    UIImage* imageNew=[UIImage thumbnailWithImageWithoutScale:newImage size:CGSizeMake(360, 360)];
    //回调
    _block(imageNew);
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 保存相册后回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) { // 保存失败
        
        [MBProgressHUD showError:@"保存失败" toView:self.view];
        
    }else{ // 保存成功
        [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
    }
}
#pragma mark - 清屏
- (IBAction)clearScreen:(id)sender {
    [self.paintView clearScreen];
}
#pragma mark - 撤销
- (IBAction)undo:(id)sender {
    [self.paintView undo];
}
#pragma mark - 橡皮擦
- (IBAction)eraser:(id)sender {
    [self.paintView eraser];
}
#pragma mark - 选择照片
- (IBAction)selectedPicture:(id)sender {
    
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
// 选中照片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取选中图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 创建处理图片的view
    TCHandleImageView *handleView = [[TCHandleImageView alloc] initWithFrame:self.paintView.frame];
    // 定义block:相当于自己的小弟，到时候直接吩咐做事
    handleView.block = ^(UIImage *image){
        
        _paintView.image = image;
    };
    
    handleView.image = image;
    
    [self.view addSubview:handleView];
    //将上面左边下面都往前一个图层
    [self.view bringSubviewToFront:self.leftView];
    [self.view bringSubviewToFront:self.bottomView];
    [self.view bringSubviewToFront:self.topView];
    
    // 取消Modal
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paintView.lineWidth=self.widthSlider.value;
    UIColor* color=[UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
    self.paintView.lineColor=color;
    self .redSlider.maximumTrackTintColor=color;
    self.greenSlider.maximumTrackTintColor=color;
    self.blueSlider.maximumTrackTintColor=color;
    
}
//移动线宽Slider
- (IBAction)lineWidthValueChange:(UISlider *)sender {
    self.paintView.lineWidth=self.widthSlider.value;
}
//移动颜色Slider
- (IBAction)lineColorValueChange:(UISlider *)sender {
    UIColor* color=[UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
    self.paintView.lineColor=color;
//    self .redSlider.maximumTrackTintColor=color;
//    self.greenSlider.maximumTrackTintColor=color;
//    self.blueSlider.maximumTrackTintColor=color;
}

////支持横屏
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}

@end
