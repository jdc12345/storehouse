//
//  ApproveListModel.h
//  storehouse
//
//  Created by 万宇 on 2018/9/11.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//approvalState = 0;
//avatar = "";
//content = "\U7ef4\U4fee\U7533\U8bf7";
//createTimeString = "2018-09-10 18:07:57";
//departmentName = "\U751f\U4ea7\U90e8";
//id = 65;
//modifyTime = "<null>";
//modifyTimeString = "";
//msgStatus = 0;
//msgType = 60;
//referId = 3;
//referName = "";
//sequence = 1;
//status = 1;
//title = "\U7ef4\U4fee\U7533\U8bf7";
//toUserId = 4;
//toUserName = "";
//trueName = "\U9773\U7b49\U81e3";
//updateTimeString = "";
//userId = 4;
//userName = "\U9773\U7b49\U81e3";

#import <Foundation/Foundation.h>

@interface ApproveListModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *modifyTimeString;
@property (nonatomic, strong) NSString *createTimeString;//时间
@property (nonatomic, strong) NSString *msgType;//申请类别
@property (nonatomic, strong) NSString *msgStatus;//申请状态
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *trueName;//谁的申请
@property (nonatomic, strong) NSString *modifyTime;
@property (nonatomic, strong) NSString *referId;
@property (nonatomic, strong) NSString *departmentName;
@property (nonatomic, strong) NSString *updateTimeString;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *sequence;
@property (nonatomic, strong) NSString *toUserName;
@property (nonatomic, strong) NSString *referName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *approvalState;//审批状态；1=同意，2=驳回
//@property (nonatomic, strong) NSString *approvalTrueName;//待审批人
@end
//msgType:消息类型,
//0=SYSTEM=系统消息，
//5=MESSAGE=私信，
//10=BUY=采购申请，
//15=CHECK=验收，
//20=INPUT=入库，
//25=OUTPUT=出库，
//30=RECIPIENT=领用，
//35=BORROW=借用，
//40=REVERT=归还，
//45=RETURN=退库，
//50=OLDFORNEW=以旧换新，
//55=DAMAGED=报损，
//60=MAINTAIN=维修，
//65=SCRAP=报废，
//70=INVENTORY=盘点，
//75=TRANSFER=转移
