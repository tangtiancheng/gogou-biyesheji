//
//  TCCategory.h
//  快买
//
//  Created by 唐天成 on 15/12/28.
//  Copyright © 2015年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCategory : NSObject

/** 显示在下拉菜单的小图标 */
@property (nonatomic, copy)NSString* highlighted_icon;
@property (nonatomic, copy)NSString* icon;

/** 类别的名称 */
@property (nonatomic, copy)NSString* name;


//@property (nonatomic, copy)NSString* small_highlighted_icon;
//@property (nonatomic, copy)NSString* small_icon;

/** 子类别:里面都是字符串(子类别的名称) */
@property (nonatomic, strong)NSArray* subcategories;

/** 显示在地图上的图标 */
@property (nonatomic, copy) NSString *map_icon;
@end
