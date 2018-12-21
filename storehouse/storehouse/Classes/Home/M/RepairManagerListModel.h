//
//  RepairManagerListModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/21.
//  Copyright © 2018 wanyu. All rights reserved.
//
//applyStatus = 2;
//assetId = 18;
//assetName = "\U4e09\U661f\U624b\U673a";
//auditor = 3;
//auditorDateString = "2018-12-21";
//barcode = zyyy00000000000000010;
//comment = "\U4e09\U661f\U624b\U673a\U5c4f\U5e55\U788e\U4e86";
//cost = 0;
//createTimeString = "";
//departmentCode = 02;
//departmentName = "\U9500\U552e\U90e8";
//gmtCreateString = "2018-12-21 14:44:08";
//gmtModifiedString = "2018-12-21 14:44:28";
//id = 21;
//inputDateString = "";
//inputUserId = 0;
//inputUserName = "";
//isFixed = 0;
//mainType = 0;
//maintenance = "";
//num = 0;
//rejectReason = "";
//repairDateString = "2018-12-21";
//status = 1;
//totalNum = 1;
//updateTimeString = "";
//userId = 3;
//userName = "\U5218\U6d77\U4e1c";
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RepairManagerListModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *assetName;//物品名称
@property (nonatomic, strong) NSString *assetId;
@property (nonatomic, strong) NSString *userName;//申请人
@property (nonatomic, strong) NSString *comment;//故障说明
@property (nonatomic, strong) NSString *maintenance;//维修方
//@property (nonatomic, strong) NSString *maintenance;//所在位置
@property (nonatomic, strong) NSString *departmentName;//部门
@property (nonatomic, copy) NSString *rejectReason;//审批备注
@property (nonatomic, copy) NSString *barcode;//资产编码
@property (nonatomic, copy) NSString *mainType;//维修类型
@property (nonatomic, copy) NSString *auditorDateString;//申请时间
@end

NS_ASSUME_NONNULL_END
