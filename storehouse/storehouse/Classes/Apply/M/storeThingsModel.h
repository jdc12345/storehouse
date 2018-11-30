//
//  storeThingsModel.h
//  storehouse
//
//  Created by 万宇 on 2018/9/5.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//addressCode = 01;
//assetName = "\U7535\U8111";
//assetStateId = 1;
//assetStateName = "";
//assetType = 1;
//assetUseId = 1;
//assetUseName = "";
//barcode = zyyy0000000000000001;
//batchNumber = "";
//budget = 0;
//buyModeId = 1;
//buyModeName = "";
//buyNo = 1;
//buyTimeString = "2018-08-14 00:00:00";
//categoryCode = 01;
//categoryName = "\U529e\U516c\U7528\U54c1";
//comment = "";
//companyId = 0;
//companyName = "";
//createTimeString = "";
//departmentCode = 01;
//documentMaker = 0;
//environment = "";
//extendedAttribute = "";
//guarantee = 0;
//humidity = 0;
//id = 1;
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
//saveUserName = "";
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
//worth = 0;
#import <Foundation/Foundation.h>

@interface storeThingsModel : NSObject
@property (nonatomic, strong) NSString *info_id;//编号
@property (nonatomic, strong) NSString *categoryCode;//分类编码
@property (nonatomic, strong) NSString *categoryName;//分类名称
@property (nonatomic, strong) NSString *addressCode;//存放地点编码
@property (nonatomic, strong) NSString *assetName;//资产名称
@property (nonatomic, strong) NSString *parentId;//附属于哪个资产
@property (nonatomic, strong) NSString *assetType;//资产类型
@property (nonatomic, strong) NSString *num;//该资产库存数
@property (nonatomic, assign) BOOL isSelected;//该数据是否被选中
@property (nonatomic, strong) NSString *barcode;//二维码编码
@end
