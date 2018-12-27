//
//  ReplaceApplyDetailModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/27.
//  Copyright © 2018 wanyu. All rights reserved.
//
//{
//    applyStatus = 2;
//    assetId = 65;
//    assetName = "\U5143\U5b9d";
//    auditorDateString = "2018-12-27";
//    auditorUserId = 3;
//    auditorUserName = "";
//    changeDateString = "2018-12-27";
//    comment = "\U6d4b\U8bd5";
//    createTimeString = "";
//    departmentCode = 02;
//    departmentName = "\U9500\U552e\U90e8";
//    depreciationState = 0;
//    documentDateString = "";
//    documentUserId = 0;
//    documentUserName = "";
//    gmtCreateString = "2018-12-27 11:42:59";
//    gmtModifiedString = "2018-12-27 11:43:10";
//    id = 8;
//    newAssetId = 65;
//    newAssetName = "\U5143\U5b9d";
//    num = 4;
//    outboundDateString = "2018-12-27";
//    rejectReason = "";
//    status = 1;
//    totalNum = 5;
//    updateTimeString = "";
//    userId = 3;
//    userName = "\U5218\U6d77\U4e1c";
//}
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplaceApplyDetailModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *assetName;//物品名称
@property (nonatomic, strong) NSString *userName;//申请人
@property (nonatomic, strong) NSString *comment;//说明
@property (nonatomic, strong) NSString *info_newAssetName;//新资产名称
@property (nonatomic, strong) NSString *departmentName;//部门
@property (nonatomic, copy) NSString *info_newAssetId;//新资产id
@property (nonatomic, copy) NSString *num;//出库数量
@property (nonatomic, copy) NSString *totalNum;//申请数量
@property (nonatomic, copy) NSString *outboundDateString;//出库时间
@property (nonatomic, copy) NSString *gmtCreateString;//申请时间
@end

NS_ASSUME_NONNULL_END
