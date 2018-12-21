//
//  RepairManagerVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/21.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"
#import "RepairManagerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RepairManagerVC : LaunchBaseVC
@property (nonatomic,assign) NSInteger state;//申请状态：1待维修，2维修记录
@property (nonatomic, strong) RepairManagerListModel *model;//传过来的点击数据
@end

NS_ASSUME_NONNULL_END
