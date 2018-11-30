//
//  AssetsManageTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/11/18.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsManageTVCell : UITableViewCell
@property(nonatomic,weak)UILabel *numLabel;//序号
@property(nonatomic,strong)AssetModel *assetModel;//资产model

@end

NS_ASSUME_NONNULL_END
