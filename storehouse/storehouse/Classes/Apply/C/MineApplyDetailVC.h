//
//  MineApplyDetailVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/17.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"
#import "LaunchListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MineApplyDetailVC : LaunchBaseVC
/**
 *  从列表传过来的审批模型数据
 */
@property (nonatomic, strong) LaunchListModel *model;
@property (nonatomic,assign) NSInteger index;//申请状态：0审批中，1被驳回，2已完成，3已失效
@end

NS_ASSUME_NONNULL_END