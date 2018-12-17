//
//  LaunchTypeTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/8/15.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchTypeModel.h"

@interface LaunchTypeTVCell : UITableViewCell
//- (void)setLaunchTypeModel:(CPXLaunchTypeModel *)typeModel cellType:(CPXLaunchTypeCellStyle)style;
@property (nonatomic, strong) LaunchTypeModel *model;//分类数据类型
+ (CGFloat)cellHeight;
@end
