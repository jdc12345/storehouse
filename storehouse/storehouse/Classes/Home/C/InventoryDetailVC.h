//
//  InventoryDetailVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/11.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"
#import "HistoryInventoryListModel.h"
#import "InventoryScanVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface InventoryDetailVC : LaunchBaseVC
@property(nonatomic,strong)HistoryInventoryListModel *infoModel;//传过来的点击cell的model
@end

NS_ASSUME_NONNULL_END
