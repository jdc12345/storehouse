//
//  GetApplyDetailModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/16.
//  Copyright © 2018 wanyu. All rights reserved.
//
//    applyStatus = 0;
//    assetList =     (
//                     {
//                         assetsId = 1;
//                         assetsName = "\U7535\U8111";
//                         categoryCode = 01;
//                         categoryName = "\U529e\U516c\U7528\U54c1";
//                         createTimeString = "";
//                         documentDateString = "";
//                         documentMaker = 0;
//                         id = 207;
//                         recipientsDateString = "2018-11-28 00:00:00";
//                         recipientsId = 46;
//                         recipientsName = "";
//                         status = 1;
//                         updateTimeString = "";
//                     },

//                     );
//    auditor = 0;
//    auditorDateString = "";
//    comment = "";
//    createTimeString = "";
//    departmentCode = 02;
//    departmentName = "\U9500\U552e\U90e8";
//    documentDateString = "";
//    documentMaker = 0;
//    gmtCreateString = "2018-11-28 16:05:19";
//    gmtModifiedString = "";
//    id = 46;
//    recipientsDateString = "2018-11-28 00:00:00";
//    rejectReason = "";
//    status = 1;
//    updateTimeString = "";
//    userId = 3;
//    userName = "\U5218\U6d77\U4e1c";
//退库数据
//{
//    applyStatus = 2;
//    assetList =     (
//    );
//    auditor = 3;
//    auditorDateString = "2018-12-27";
//    comment = "";
//    createTimeString = "";
//    departmentCode = 02;
//    departmentName = "\U9500\U552e\U90e8";
//    documentDateString = "";
//    documentMaker = 0;
//    gmtCreateString = "2018-12-27 17:14:53";
//    gmtModifiedString = "2018-12-27 17:14:58";
//    id = 10;
//    inboundDateString = "2018-12-27";
//    rejectReason = "";
//    returnDateString = "2018-12-27";
//    status = 1;
//    updateTimeString = "";
//    userId = 3;
//    userName = "\U5218\U6d77\U4e1c";
//}
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetApplyDetailModel : NSObject
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, strong) NSArray *assetList;//领用物品列表
@property (nonatomic, copy) NSString *userName;//申请人
@property (nonatomic, copy) NSString *comment;//备注说明
@property (nonatomic, copy) NSString *departmentName;//部门
@property (nonatomic, copy) NSString *rejectReason;//审批备注
@property (nonatomic, copy) NSString *gmtCreateString;//申请时间
//出库入库(领用)
@property (nonatomic, copy) NSString *outboundDateString;//领用日期来判断是否已经领用，日期为空=未出库，不为空=已出库
//出库入库(退库)
@property (nonatomic, copy) NSString *inboundDateString;//状态：inboundDateString 实际入库/退库日期 来判断状态，为空=未入库，不为空=已入库
@end

NS_ASSUME_NONNULL_END
