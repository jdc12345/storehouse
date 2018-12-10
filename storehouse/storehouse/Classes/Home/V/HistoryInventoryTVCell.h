//
//  HistoryInventoryTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/12/10.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryInventoryListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HistoryInventoryTVCell : UITableViewCell
/**
 *  cell 的模型数据
 */
@property (nonatomic, strong) HistoryInventoryListModel *model;
///**
// *  类型 状态
// */
//@property (nonatomic, assign) NSInteger processStatus;

//- (void)setModel:(HistoryInventoryListModel *)model processStatus:(NSInteger)processStatus;
//
//+ (CGFloat) calculateRowHeightWithIndex:(NSInteger)index model:(CPXLaunchCellDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
