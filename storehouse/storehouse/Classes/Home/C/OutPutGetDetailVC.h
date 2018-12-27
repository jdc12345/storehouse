//
//  OutPutGetDetailVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/26.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"
#import "GetApplyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutPutGetDetailVC : LaunchBaseVC
/**
 *
 */
@property (nonatomic, strong) GetApplyDetailModel *model;
@property (nonatomic,copy) NSString *outboundDateString;//根据 outboundDate 领用日期来判断是否已经领用，日期为空=未出库，不为空=已出库
@end

NS_ASSUME_NONNULL_END
