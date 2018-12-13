//
//  InventoryAssetModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/12.
//  Copyright © 2018 wanyu. All rights reserved.
//
//addressCode = "";
//addressName = "";
//assetsId = 1;
//assetsName = "\U7535\U8111";
//barcode = zyyy0000000000000001;
//comment = "";
//createTimeString = "";
//gmtCreateString = "2018-12-07 15:07:15";
//gmtModifiedString = "";
//id = 218;
//inventoryFlag = 1;//是否已经盘点过

//inventoryId = 19;
//inventoryName = "";
//inventoryNum = 1;
//num = 1;
//orgAddressCode = 01;
//orgAddressName = "\U529e\U516c\U697c";
//profitAndLoss = 0;
//result = 1;
//saveUserId = 1;
//saveUserName = admin;
//status = 1;
//suggest = "";
//updateTimeString = "";
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InventoryAssetModel : NSObject
@property (nonatomic, copy) NSString*info_id;//整个盘点id;
@property (nonatomic, copy) NSString*inventoryId;//盘点编号;
@property (nonatomic, copy) NSString*inventoryName;//盘点名称;
@property (nonatomic, copy) NSString* assetsName;//资产名称
@property (nonatomic, copy) NSString* addressName;//现保存地
@property (nonatomic, copy) NSString*addressCode;//现存放地点编码
@property (nonatomic, copy) NSString*orgAddressCode;//应存放地点编码
@property (nonatomic, copy) NSString*orgAddressName;//应存放地点
@property (nonatomic, copy) NSString*assetsId;//资产id
@property (nonatomic, copy) NSString*createTimeString;//开始时间
@property (nonatomic, copy) NSString*gmtCreateString;//创建日期
@property (nonatomic, copy) NSString*gmtModifiedString;//更新日期
@property (nonatomic, copy) NSString *num;//资产数量
@property (nonatomic, copy) NSString*inventoryNum;//已盘点的资产数量
@property (nonatomic, copy) NSString *barcode;//资产编码
@property (nonatomic, copy) NSString *comment;//资产备注（200字以内）
@property (nonatomic, copy) NSString*profitAndLoss;//盈亏情况
@property (nonatomic, copy) NSString*result;//处理结果
@property (nonatomic, copy) NSString*saveUserId;//保管人id
@property (nonatomic, copy) NSString* saveUserName;//保管人
@property (nonatomic, copy) NSString*suggest;//建议处理


@end

NS_ASSUME_NONNULL_END
