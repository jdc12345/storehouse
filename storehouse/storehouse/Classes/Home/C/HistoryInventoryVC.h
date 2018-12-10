//
//  HistoryInventoryVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/10.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"

@class HistoryInventoryVC,HistoryInventoryListModel;
@protocol refreshDelegate <NSObject>//协议

- (void)transViewController:(HistoryInventoryVC*)willApproveVC;//下拉刷新协议方法
- (void)transForFootRefreshWithViewController:(HistoryInventoryVC*)willApproveVC;//上拉加载协议方法
- (void)transForPushDetailWithCell:(HistoryInventoryListModel*)model;//跳转详情协议方法

@end
NS_ASSUME_NONNULL_BEGIN

@interface HistoryInventoryVC : LaunchBaseVC
@property(nonatomic,strong)NSMutableArray *inventoryList;//历史盘点数据
@property (nonatomic, assign) id<refreshDelegate>delegate;//代理属性
@end

NS_ASSUME_NONNULL_END
