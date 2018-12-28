//
//  AssetChangeRecordTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/12/28.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetChangeRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetChangeRecordTVCell : UITableViewCell
@property(nonatomic,weak)UILabel *numLabel;//序号
@property(nonatomic,strong)AssetChangeRecordModel *model;//资产变动记录model
@end

NS_ASSUME_NONNULL_END
