//
//  AssetChangeRecordModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/28.
//  Copyright © 2018 wanyu. All rights reserved.
//
//{
//    addressCode = 01;
//    addressName = "\U529e\U516c\U697c";
//    assetId = 1;
//    assetName = "\U7535\U8111";
//    auditorUserId = 1;
//    auditorUserName = "";
//    changeDateString = "2018-12-12";
//    changeDesc = "\U8d44\U4ea7\U5165\U5e93";
//    changeNum = 0;
//    createTimeString = "";
//    departmentCode = 01;
//    departmentName = "\U751f\U4ea7\U90e8";
//    id = 1;
//    orgAddressCode = 01;
//    orgAddressName = "\U529e\U516c\U697c";
//    orgDepartmentCode = 01;
//    orgDepartmentName = "";
//    orgSaveUserId = 1;
//    orgSaveUserName = "";
//    orgUseUserId = 1;
//    orgUseUserName = "";
//    saveUserId = 1;
//    saveUserName = admin;
//    status = 1;
//    updateTimeString = "";
//    useUserId = 1;
//    useUserName = "";
//}
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetChangeRecordModel : NSObject
@property (nonatomic, copy) NSString* info_id;//记录id
@property (nonatomic, copy) NSString* changeDateString;//变动日期，
@property (nonatomic, copy) NSString* changeDesc;//变动事项，
@property (nonatomic, copy) NSString* saveUserName;//关联人
//@property (nonatomic, copy) NSString* assetName;//资产名称
//@property (nonatomic, copy) NSString* addressCode;
//@property (nonatomic, copy) NSString* addressName;//保存地
//@property (nonatomic, copy) NSString* saveUserName;//保管人
//@property (nonatomic, strong) NSString *barcode;//资产编码
//@property (nonatomic, strong) NSString *categoryName;//资产类别
//@property (nonatomic, strong) NSString *assetType;//资产型号
//@property (nonatomic, copy) NSString* useTimes;//使用年限
//@property (nonatomic, strong) NSString *worth;//资产原值，资产价格
//@property (nonatomic, strong) NSString *num;//资产数量
//@property (nonatomic, strong) NSString *unit;//计量单位
//@property (nonatomic, strong) NSString *comment;//资产备注（200字以内
@end

NS_ASSUME_NONNULL_END
