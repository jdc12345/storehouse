//
//  ApproveDetailAssetTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/12/16.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproveDetailAssetModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^ifSelectedBlock)(ApproveDetailAssetModel *selModel , BOOL btnSelected);
@interface ApproveDetailAssetTVCell : UITableViewCell
//block传递选中cell的model:
@property(nonatomic,copy) ifSelectedBlock ifSelectedBlock;
@property(nonatomic,weak)UIButton *selBtn;//选择按钮
@property(nonatomic,weak)UIView *selView;//选择视图
/**
 *  资产数据
 */
@property (nonatomic, strong) ApproveDetailAssetModel *model;
@property(nonatomic,weak)UITextField *contentField;//资产数量
@end

NS_ASSUME_NONNULL_END
