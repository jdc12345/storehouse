//
//  RepairApplyDetailModel.h
//  storehouse
//
//  Created by 万宇 on 2018/9/25.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//applyStatus = 0;
//assetId = 1;
//assetName = "\U7535\U8111";
//auditor = 0;
//auditorDateString = "";
//comment = "";
//cost = 0;
//createTimeString = "";
//departmentCode = 01;
//departmentName = "\U751f\U4ea7\U90e8";
//gmtCreateString = "2018-09-21 11:46:55";
//gmtModifiedString = "";
//id = 4;
//inputDate = "<null>";
//inputDateString = "";
//inputUserId = 0;
//inputUserName = "";
//isFixed = 0;
//maintenance = "";
//rejectReason = "";
//repairDate = "<null>";
//repairDateString = "";
//status = 1;
//updateTimeString = "";
//userId = 4;
//userName = "\U9773\U7b49\U81e3";
#import <Foundation/Foundation.h>

@interface RepairApplyDetailModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *assetName;//物品名称
@property (nonatomic, strong) NSString *userName;//申请人
@property (nonatomic, strong) NSString *comment;//故障说明
@property (nonatomic, strong) NSString *maintenance;//维修方
//@property (nonatomic, strong) NSString *maintenance;//所在位置
@property (nonatomic, strong) NSString *departmentName;//部门

@end
