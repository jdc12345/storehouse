//
//  willApproveVC.h
//  storehouse
//
//  Created by 万宇 on 2018/9/10.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"

@class willApproveVC,ApproveListModel;
@protocol refreshDelegate <NSObject>//协议

- (void)transViewController:(willApproveVC*)willApproveVC;//下拉刷新协议方法
- (void)transForFootRefreshWithViewController:(willApproveVC*)willApproveVC;//上拉加载协议方法
- (void)transForPushDetailWithCell:(ApproveListModel*)model;//跳转详情协议方法

@end

@interface willApproveVC : LaunchBaseVC
@property(nonatomic,strong)NSMutableArray *approveList;//待审批数据
@property (nonatomic, assign) id<refreshDelegate>delegate;//代理属性
@end
