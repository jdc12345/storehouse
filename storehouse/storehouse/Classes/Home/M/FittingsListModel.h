//
//  FittingsListModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/21.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    assetId = 1;
//    assetName = "";
//    barcode = 1;
//    createTimeString = "";
//    id = 1;
//    maintenanceLogId = 1;
//    maintenanceLogName = "";
//    num = 1;
//    specTyp = 1;
//    status = 1;
//    updateTimeString = "";
//}
NS_ASSUME_NONNULL_BEGIN

@interface FittingsListModel : NSObject
@property (nonatomic, strong) NSString *info_id;//编号
@property (nonatomic, strong) NSString *assetName;//资产名称
@property (nonatomic, strong) NSString *assetId;//
@property (nonatomic, strong) NSString *barcode;//二维码编码
@property (nonatomic, strong) NSString *maintenanceLogId;//维修日志id
@property (nonatomic, strong) NSString *specTyp;//配件类型
@property (nonatomic, strong) NSString *num;//该配件库存数

@property (nonatomic, assign) BOOL isSelected;//该数据是否被选中

@end

NS_ASSUME_NONNULL_END
