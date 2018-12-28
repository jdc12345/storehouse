//
//  OutPutListTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/12/25.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyApplyDetailModel.h"
#import "GetApplyDetailModel.h"
#import "borrowApplyDetailModel.h"
#import "ReplaceApplyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutPutListTVCell : UITableViewCell
@property(nonatomic,weak)BuyApplyDetailModel *checkModel;//传递过来的验收列表物品数据model
@property(nonatomic,weak)GetApplyDetailModel *getModel;//传递过来的领用列表物品数据model
@property(nonatomic,weak)borrowApplyDetailModel *borrowModel;//传递过来的借用列表物品数据model
@property(nonatomic,weak)ReplaceApplyDetailModel *replaceModel;//传递过来的以旧换新列表物品数据model
@property(nonatomic,weak)GetApplyDetailModel *backModel;//传递过来的退库列表物品数据model
@end

NS_ASSUME_NONNULL_END
