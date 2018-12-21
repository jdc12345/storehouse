//
//  BuyApplyDetailModel.h
//  storehouse
//
//  Created by 万宇 on 2018/9/21.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//acceptanceDateString = "";
//acceptanceEvaluation = "";
//acceptanceOpinion = 0;
//acceptanceUserId = 0;
//acceptanceUserName = "";
//applyState = 0;
//applyStatus = 0;
//applyTimeString = "2018-09-21 00:00:00";
//applyUserId = 4;
//applyUserName = "";
//approvalDateString = "";
//approvalUserId = 0;
//approvalUserName = "";
//assetName = Apple;
//auditOpinion = "";
//buyAddress = "";
//buyCate = 1;
//buyCode = "";
//buyCount = 1;
//buyDateString = "";
//buyReason = Sd;
//buyUserId = 0;
//buyUserName = "";
//buyWorth = 0;
//companyId = 1;
//companyName = "";
//createTimeString = "";
//departmentCode = 01;
//departmentName = "\U751f\U4ea7\U90e8";
//gmtCreateString = "2018-09-21 11:48:11";
//gmtModifiedString = "";
//id = 3;
//isAgree = 0;
//producerId = 0;
//producerName = Apple;
//rejectReason = "";
//specTyp = 5;
//status = 1;
//supplierId = 0;
//supplierName = "";
//unit = "\U53f0";
//updateTimeString = "";
//worth = 10000;

#import <Foundation/Foundation.h>

@interface BuyApplyDetailModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *assetName;//物品名称
@property (nonatomic, strong) NSString *unit;//计量单位
@property (nonatomic, strong) NSString *worth;//预算单价
@property (nonatomic, strong) NSString *buyCount;//采购数量
@property (nonatomic, strong) NSString *producerName;//生产厂家
@property (nonatomic, strong) NSString *buyCate;//采购类别
@property (nonatomic, strong) NSString *buyReason;//采购理由
@property (nonatomic, strong) NSString *departmentName;//部门
@property (nonatomic, strong) NSString *specTyp;//规格型号
@property (nonatomic, copy) NSString *rejectReason;//审批备注
@property (nonatomic, copy) NSString *applyTimeString;//申请时间
//采购订单
@property (nonatomic, copy) NSString *buyAddress;//采购地点
@property (nonatomic, copy) NSString *buyWorth;//采购价格
@property (nonatomic, copy) NSString *acceptanceEvaluation;//验收评价
@property (nonatomic, copy) NSString *acceptanceOpinion;//验收意见
@end
