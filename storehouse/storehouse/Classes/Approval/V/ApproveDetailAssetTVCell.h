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
@property (nonatomic, strong) ApproveDetailAssetModel *model;//审批页面传过来
@property(nonatomic,weak)UITextField *contentField;//资产数量
@property (nonatomic,copy) NSString *outboundDateString;//根据 outboundDate 出库日期来判断是否已经出库，日期为空=未出库，不为空=已出库
@property (nonatomic, strong) ApproveDetailAssetModel *outPutmodel;//出入库领用页面传过来
@property (nonatomic, strong) ApproveDetailAssetModel *borrowModel;//出入库借用页面传过来
@property (nonatomic,copy) NSString *inboundDateString;//状态：inboundDateString 实际入库/退库日期 来判断状态，为空=未入库，不为空=已入库
@property (nonatomic, strong) ApproveDetailAssetModel *BackStoreModel;//出入库退库页面传过来
@end

NS_ASSUME_NONNULL_END
