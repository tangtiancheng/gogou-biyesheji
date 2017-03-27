//
//  TCDealCell.m
//  快买
//
//  Created by 唐天成 on 16/1/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCDealCell.h"
#import "TCDeal.h"
#import "UIImageView+WebCache.h"
@interface TCDealCell()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//描述
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
//当前价格
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
//原价
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
//销售量
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
//遮罩
@property (weak, nonatomic) IBOutlet UIButton *coverView;
//选中的勾
@property (weak, nonatomic) IBOutlet UIImageView *checkView;
@end

@implementation TCDealCell
-(void)awakeFromNib{
    self.backgroundView=[[UIImageView alloc]initWithImage: [UIImage resizableImageNamed:@"bg_dealcell"]];
    //让原始价格中间加一横线
    

}
-(void)setDeal:(TCDeal *)deal{
    _deal=deal;
    [self.imageVIew sd_setImageWithURL:_deal.s_image_url placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%d", deal.purchase_count];
    
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"¥ %@", deal.current_price];
    NSUInteger dotLoc = [self.currentPriceLabel.text rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) {
        // 超过2位小数
        if (self.currentPriceLabel.text.length - dotLoc > 3) {
            self.currentPriceLabel.text = [self.currentPriceLabel.text substringToIndex:dotLoc + 3];
        }
    }

    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥ %@", deal.list_price];
    self.titleLabel.text=deal.title;
    self.descLabel.text=deal.desc;
    
    // 根据模型属性来控制cover的显示和隐藏
    self.coverView.hidden = !deal.isEditting;
    
    // 根据模型属性来控制打钩的显示和隐藏
    self.checkView.hidden = !deal.isChecking;
}

//点击遮罩
- (IBAction)coverClick:(UIButton*)sender {
    // 设置模型
    self.deal.checking = !self.deal.isChecking;
//    NSLog(@"%d",self.deal.checking);
    self.checkView.hidden=!self.checkView.hidden;
//    NSLog(@"%d",self.checkView.hidden);
    if([self.delegate respondsToSelector:@selector(coverViewDidChange:)]){
        [self.delegate coverViewDidChange:self];
    }
}
@end
