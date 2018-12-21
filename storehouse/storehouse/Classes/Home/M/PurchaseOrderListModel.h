//
//  PurchaseOrderListModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/19.
//  Copyright © 2018 wanyu. All rights reserved.
//
//{
//    acceptanceDateString = "";
//    acceptanceEvaluation = "";
//    acceptanceOpinion = 0;
//    acceptanceUserId = 0;
//    acceptanceUserName = "";
//    applyState = 1;
//    applyStatus = 2;
//    applyTimeString = "2018-12-16";
//    applyUserId = 4;
//    applyUserName = "\U9773\U7b49\U81e3";
//    approvalDateString = "2018-12-17";
//    approvalUserId = 3;
//    approvalUserName = "";
//    assetName = Opop;
//    auditOpinion = "";
//    buyAddress = "";
//    buyCate = 2;
//    buyCode = "";
//    buyCount = 5;
//    buyDateString = "2018-12-17";
//    buyName = "";
//    buyReason = "";
//    buyUserId = 3;
//    buyUserName = "";
//    buyWorth = 0;
//    comment = "\U6d4b\U8bd5\U91c7\U8d2d";
//    companyId = 1;
//    companyName = "";
//    createTimeString = "";
//    departmentCode = 01;
//    departmentName = "\U751f\U4ea7\U90e8";
//    gmtCreateString = "2018-12-16 17:09:36";
//    gmtModifiedString = "2018-12-17 11:45:49";
//    id = 12;
//    isAgree = 0;
//    producerId = 0;
//    producerName = T;
//    rejectReason = "";
//    specTyp = W;
//    status = 1;
//    supplierId = 0;
//    supplierName = "";
//    unit = "\U4e2a";
//    updateTimeString = "";
//    worth = 0;
//}
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseOrderListModel : NSObject
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *assetName;//物品名称
@property (nonatomic, copy) NSString *unit;//计量单位
@property (nonatomic, copy) NSString *worth;//预算单价
@property (nonatomic, copy) NSString *buyCount;//采购数量
@property (nonatomic, copy) NSString *producerName;//生产厂家
@property (nonatomic, copy) NSString *buyCate;//采购类别
@property (nonatomic, copy) NSString *buyReason;//采购理由
@property (nonatomic, copy) NSString *departmentName;//部门
@property (nonatomic, copy) NSString *specTyp;//规格型号
@property (nonatomic, copy) NSString *rejectReason;//审批备注
@property (nonatomic, copy) NSString *applyTimeString;//申请时间
@property (nonatomic, copy) NSString *applyUserName;//申请者名字
@end

NS_ASSUME_NONNULL_END
