//
//  OutPutBackStoreDetailVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/27.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"
#import "GetApplyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutPutBackStoreDetailVC : LaunchBaseVC
@property (nonatomic, strong) GetApplyDetailModel *model;
@property (nonatomic,copy) NSString *inboundDateString;//inboundDateString 实际入库/退库日期 来判断状态，为空=未入库，不为空=已入库
@end

NS_ASSUME_NONNULL_END
