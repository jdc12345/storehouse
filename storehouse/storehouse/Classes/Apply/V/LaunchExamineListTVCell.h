//
//  LaunchExamineListTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/8/14.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchListModel.h"

@interface LaunchExamineListTVCell : UITableViewCell
/**
 *  cell 的模型数据
 */
@property (nonatomic, strong) LaunchListModel *model;
/**
 *  类型 状态
 */
@property (nonatomic, assign) NSInteger processStatus;

- (void)setModel:(LaunchListModel *)model processStatus:(NSInteger)processStatus;
//
//+ (CGFloat) calculateRowHeightWithIndex:(NSInteger)index model:(CPXLaunchCellDetailModel *)model;
@end
