//
//  RepairApplyDetailModel.h
//  storehouse
//
//  Created by 万宇 on 2018/9/25.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//{
//    applyStatus = 0;
//    assetId = 31;
//    assetName = "\U7535\U8111";
//    auditor = 0;
//    auditorDateString = "";
//    barcode = zyyy0000000000000001;
//    comment = "";
//    cost = 0;
//    createTimeString = "";
//    departmentCode = 01;
//    departmentName = "\U751f\U4ea7\U90e8";
//    gmtCreateString = "2018-11-29 11:54:34";
//    gmtModifiedString = "";
//    id = 18;
//    inputDate = "<null>";
//    inputDateString = "";
//    inputUserId = 0;
//    inputUserName = "";
//    isFixed = 0;
//    mainType = 1;
//    maintenance = "";
//    num = 0;
//    rejectReason = "";
//    repairDateString = "2018-11-29";
//    status = 1;
//    totalNum = 4;
//    updateTimeString = "";
//    userId = 4;
//    userName = "\U9773\U7b49\U81e3";
//}

#import <Foundation/Foundation.h>

@interface RepairApplyDetailModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *assetName;//物品名称
@property (nonatomic, strong) NSString *userName;//申请人
@property (nonatomic, strong) NSString *comment;//故障说明
@property (nonatomic, strong) NSString *maintenance;//维修方
//@property (nonatomic, strong) NSString *maintenance;//所在位置
@property (nonatomic, strong) NSString *departmentName;//部门
@property (nonatomic, copy) NSString *rejectReason;//审批备注
@property (nonatomic, copy) NSString *barcode;//资产编码
@property (nonatomic, copy) NSString *mainType;//维修类型
//@property (nonatomic, copy) NSString *repairDateString;//修复时间(申请审批详情页面需要从新赋值申请时间)
@property (nonatomic, copy) NSString *gmtCreateString;//申请时间
//维修管理
@property (nonatomic, copy) NSString *isFixed;//是否修复
@property (nonatomic, copy) NSString *repairDateString;//修复时间
@end
//{
//    applyStatus = 2;
//    assetId = 1;
//    assetName = "\U7535\U8111";
//    auditor = 3;
//    auditorDateString = "2018-11-21";
//    barcode = "";
//    comment = "\U663e\U793a\U5668\U635f\U574f";
//    cost = 0;
//    createTimeString = "";
//    departmentCode = 02;
//    departmentName = "\U9500\U552e\U90e8";
//    gmtCreateString = "2018-11-20 10:13:32";
//    gmtModifiedString = "2018-12-20 10:27:27";
//    id = 1;
//    inputDateString = "2018-12-20";
//    inputUserId = 3;
//    inputUserName = "";
//    isFixed = 1;
//    mainType = 0;
//    maintenance = "";
//    num = 0;
//    rejectReason = "";
//    repairDateString = "2018-11-27";
//    status = 1;
//    totalNum = 0;
//    updateTimeString = "";
//    userId = 3;
//    userName = "\U5218\U6d77\U4e1c";
//}
