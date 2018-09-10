//
//  LaunchListModel.h
//  storehouse
//
//  Created by 万宇 on 2018/8/15.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//"modifyTimeString": "",
//"createTimeString": "2018-08-15 11:10:43",
//"msgType": 10,
//"title": "",
//"msgStatus": 0,
//"toUserId": 1,
//"content": "",
//"trueName": "admin",
//"modifyTime": null,
//"referId": 1,
//"id": 1,
//"departmentName": "",
//"updateTimeString": "",
//"avatar": "",
//"userName": "",
//"userId": 1,
//"sequence": 0,
//"toUserName": "",
//"referName": "",
//"status": 1

#import <Foundation/Foundation.h>

@interface LaunchListModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *modifyTimeString;
@property (nonatomic, strong) NSString *createTimeString;//时间
@property (nonatomic, strong) NSString *msgType;//申请类别
@property (nonatomic, strong) NSString *msgStatus;//申请状态
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *trueName;
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
@property (nonatomic, strong) NSString *approvalTrueName;//待审批人
@end
