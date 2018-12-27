//
//  CheckdetailVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/25.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"
#import "BuyApplyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckdetailVC : LaunchBaseVC
@property (nonatomic,assign) NSInteger state;//0=待验收，1=已验收，2=已退货
@property (nonatomic, strong) BuyApplyDetailModel *model;//传过来的点击数据
@end

NS_ASSUME_NONNULL_END
