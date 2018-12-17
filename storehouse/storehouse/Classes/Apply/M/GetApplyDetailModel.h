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
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetApplyDetailModel : NSObject
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, strong) NSArray *assetList;//领用物品列表
@property (nonatomic, copy) NSString *userName;//申请人
@property (nonatomic, copy) NSString *comment;//备注说明
@property (nonatomic, copy) NSString *departmentName;//部门
@property (nonatomic, copy) NSString *rejectReason;//审批备注
@end

NS_ASSUME_NONNULL_END
