//
//  AssetModel.h
//  storehouse
//
//  Created by 万宇 on 2018/11/19.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <Foundation/Foundation.h>
//addressCode = 01;
//addressName = "\U529e\U516c\U697c";
//assetName = "\U4f20\U771f\U673a";
//assetStateId = 1;
//assetStateName = "";
//assetType = 1;
//assetUseId = 1;
//assetUseName = "";
//barcode = zyyy0000000000000010;
//batchNumber = "";
//budget = 0;
//buyModeId = 1;
//buyModeName = "";
//buyNo = 1;
//buyTimeString = "2018-08-14 00:00:00";
//categoryCode = 02;
//categoryName = "\U56fa\U5b9a\U8d44\U4ea7";
//comment = "";
//companyId = 0;
//companyName = "";
//createTimeString = "";
//departmentCode = 01;
//departmentName = "\U751f\U4ea7\U90e8";
//documentMaker = 0;
//environment = "";
//extendedAttribute = "";
//guarantee = 0;
//humidity = 0;
//id = 10;
//images = "";
//invoiceNumber = "";
//maintenanceCycle = 0;
//originalCode = 1;
//parentId = 0;
//parentName = "";
//passEntryTimeString = "2018-08-14 00:00:00";
//producerId = 0;
//producerName = "";
//residualRate = 0;
//saveUserId = 1;
//saveUserName = admin;
//sortNum = "";
//specTyp = 1;
//status = 1;
//supplierId = 1;
//supplierName = "";
//temperature = 0;
//trade = 0;
//unitCode = 1;
//updateTimeString = "";
//useState = 1;
//useTimes = 1;
//useUserId = 1;
//useUserName = "";
//worth = 500;
NS_ASSUME_NONNULL_BEGIN

@interface AssetModel : NSObject
@property (nonatomic, copy) NSString* info_id;//资产id
@property (nonatomic, copy) NSString* assetName;//资产名称
@property (nonatomic, copy) NSString* addressName;//保存地
@property (nonatomic, copy) NSString* saveUserName;//保管人
@property (nonatomic, copy) NSString* useUserId;//保管人id
@property (nonatomic, copy) NSString* saveUserId;//使用人
@property (nonatomic, strong) NSString *barcode;//资产编码
@property (nonatomic, strong) NSString *categoryName;//资产类别
//@property (nonatomic, strong) NSString *assetType;//资产型号
@property (nonatomic, strong) NSString *specTyp;//资产型号
@property (nonatomic, copy) NSString* useTimes;//使用年限
@property (nonatomic, strong) NSString *worth;//资产原值，资产价格
@property (nonatomic, strong) NSString *num;//资产数量
@property (nonatomic, strong) NSString *unit;//计量单位
@property (nonatomic, strong) NSString *comment;//资产备注（200字以内）

@end

NS_ASSUME_NONNULL_END
