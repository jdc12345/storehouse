//
//  PurchaseOrderDetailVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/20.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"
#import "PurchaseOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface PurchaseOrderDetailVC : LaunchBaseVC
@property (nonatomic,assign) NSInteger state;//申请状态：1待采购，2采购中，3已入库，4已退货
@property (nonatomic, strong) PurchaseOrderListModel *model;//传过来的点击数据
@end

NS_ASSUME_NONNULL_END
