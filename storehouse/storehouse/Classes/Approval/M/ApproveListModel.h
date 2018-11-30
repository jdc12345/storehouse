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
