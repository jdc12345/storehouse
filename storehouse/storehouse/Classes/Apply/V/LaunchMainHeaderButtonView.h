//
//  LaunchMainHeaderButtonView.h
//  storehouse
//
//  Created by 万宇 on 2018/6/6.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//头部试图按钮类型
typedef NS_ENUM(NSInteger,LaunchMainHeaderButtonType) {
    LaunchMainHeaderButtonTypeApproval   ,//申请中
    LaunchMainHeaderButtonTypeReject     ,//被驳回
    LaunchMainHeaderButtonTypeConfirm    ,//已完成
    LaunchMainHeaderButtonTypeLoss       ,//已失效
    
};
#import <UIKit/UIKit.h>

@interface LaunchMainHeaderButtonView : UIControl

@property (nonatomic, assign) LaunchMainHeaderButtonType type;


@property (nonatomic, assign) BOOL isHiddenRedTipPoint;
@end
