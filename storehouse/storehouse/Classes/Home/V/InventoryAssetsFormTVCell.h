//
//  InventoryAssetsFormTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/12/11.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface InventoryAssetsFormTVCell : UITableViewCell
@property (nonatomic, strong) InventoryAssetModel* inventoryAssetModel;//传过来的盘点资产
@end

NS_ASSUME_NONNULL_END
