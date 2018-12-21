//
//  PurchaseOrderListTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/12/19.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseOrderListModel.h"
#import "RepairManagerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseOrderListTVCell : UITableViewCell
///*采购订单列表
- (void)setModel:(PurchaseOrderListModel *)model processStatus:(NSInteger)processStatus;
///*维修申请列表
- (void)setRepairModel:(RepairManagerListModel *)model processStatus:(NSInteger)processStatus;

@end

NS_ASSUME_NONNULL_END
