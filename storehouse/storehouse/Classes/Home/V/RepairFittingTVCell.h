//
//  RepairFittingTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/12/21.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FittingsListModel.h"

typedef void (^ifSelectedBlock)(FittingsListModel *selModel , BOOL btnSelected);
NS_ASSUME_NONNULL_BEGIN

@interface RepairFittingTVCell : UITableViewCell
//block传递选中cell的model:
@property(nonatomic,copy) ifSelectedBlock ifSelectedBlock;
@property(nonatomic,weak)UIButton *selBtn;//选择按钮
@property(nonatomic,weak)UIView *selView;//选择视图
@property(nonatomic,weak)FittingsListModel *storeThingModel;//传递过来的配件列表物品数据model
@property(nonatomic,weak)FittingsListModel *selectedThingsModel;//传递过来的已选中配件列表物品数据model
@property(nonatomic,weak)UITextField *contentField;//配件数量
@end

NS_ASSUME_NONNULL_END
