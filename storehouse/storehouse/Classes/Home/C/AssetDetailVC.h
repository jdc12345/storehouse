//
//  AssetDetailVC.h
//  storehouse
//
//  Created by 万宇 on 2018/11/20.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"
#import "AssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetDetailVC : UIViewController
@property(nonatomic,strong)NSString *info_id;//扫一扫页面传过来的资产id
@property(nonatomic,strong)AssetModel *assetModel;//资产管理页面传过来的资产model
@end

NS_ASSUME_NONNULL_END
