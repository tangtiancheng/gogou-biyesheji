//
//  TCDeal.h
//  快买
//
//  Created by 唐天成 on 16/1/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCDeal : NSObject
/** 团购单ID */
@property (copy, nonatomic) NSString *deal_id;
/** 团购标题 */
@property (copy, nonatomic) NSString *title;
/** 团购描述 */
@property (copy, nonatomic) NSString *desc;
/** 如果想完整地保留服务器返回数字的小数位数(没有小数\1位小数\2位小数等),那么就应该用NSNumber */
/** 团购包含商品原价值 */
@property (strong, nonatomic) NSNumber *list_price;
/** 团购价格 */
@property (strong, nonatomic) NSNumber *current_price;
/** 团购当前已购买数 */
@property (assign, nonatomic) int purchase_count;
/** 团购图片链接，最大图片尺寸450×280 */
@property (copy, nonatomic) NSString *image_url;
/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (copy, nonatomic) NSString *s_image_url;
/** string	团购HTML5页面链接，适用于移动应用和联网车载应用 */
@property (nonatomic, copy) NSString *deal_h5_url;

/** 是否正在编辑 */
@property (nonatomic, assign, getter=isEditting) BOOL editing;
/** 是否被勾选了 */
@property (nonatomic, assign, getter=isChecking) BOOL checking;

//该团购属于什么类别:电影还是饮食
@property (nonatomic, strong) NSArray *categories;
//支持该团购商品的店家
@property (nonatomic, strong)NSArray* businesses;

@end
