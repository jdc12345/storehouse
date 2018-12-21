//
//  ScrapApplyDetailModel.h
//  storehouse
//
//  Created by 万宇 on 2018/9/25.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//applyStatus = 0;
//assetsId = 13;
//assetsName = "\U529e\U516c\U684c";
//auditor = 0;
//comment = "";
//createTimeString = "";
//departmentCode = 02;
//departmentName = "\U9500\U552e\U90e8";
//documentMaker = 0;
//gmtCreateString = "2018-11-28 15:19:17";
//gmtModifiedString = "";
//id = 1;
//isFixed = 0;
//num = 0;
//officialDocumentNo = "";
//operatorDate = "<null>";
//operatorUserId = 0;
//operatorUserName = "";
//rejectReason = "";
//scrapDateString = "2018-11-28";
//scrapModeId = 1;
//scrapModeName = "\U8fc7\U671f";
//status = 1;
//totalNum = 1;
//updateTimeString = "";
//userId = 3;
//userName = "\U5218\U6d77\U4e1c";

#import <Foundation/Foundation.h>

@interface ScrapApplyDetailModel : NSObject
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *assetsName;//物品名称
@property (nonatomic, copy) NSString *userName;//申请人
@property (nonatomic, copy) NSString *comment;//报废理由
@property (nonatomic, copy) NSString *scrapModeId;//报废方式
@property (nonatomic, copy) NSString *scrapDateString;//
@property (nonatomic, copy) NSString *departmentName;//部门
@property (nonatomic, copy) NSString *rejectReason;//审批备注
@property (nonatomic, copy) NSString *gmtCreateString;//申请时间
@end
