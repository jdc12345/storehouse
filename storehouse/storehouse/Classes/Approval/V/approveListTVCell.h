//
//  approveListTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/9/11.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproveListModel.h"

@interface approveListTVCell : UITableViewCell
/**
 *  审批模型数据
 */
@property (nonatomic, strong) ApproveListModel *model;
@end
