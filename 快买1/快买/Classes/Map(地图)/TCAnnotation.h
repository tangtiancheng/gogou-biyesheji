//
//  TCAnnotation.h
//  快买
//
//  Created by 唐天成 on 16/1/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TCAnnotation : NSObject
//必须声明一个坐标属性 (名字一模一样)
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//title/subtitle属性可选
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong)NSString* icon;

@end
