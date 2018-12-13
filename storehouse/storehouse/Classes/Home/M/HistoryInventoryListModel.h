//
//  HistoryInventoryListModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/10.
//  Copyright © 2018 wanyu. All rights reserved.
//
//auditor = 0;
//auditorDateString = "";
//beginDateString = "2018-12-07 00:00:00";
//closedDateString = "";
//closedMaker = 0;
//createTimeString = "";
//description = message;
//documentDateString = "";
//documentMaker = 0;
//endDateString = "";
//id = 19;
//inventoryUserId = 0;
//inventoryUserName = "";
//status = 1;
//subject = "\U5e93\U623f2\U76d8\U70b9";
//updateTimeString = "";
//willBalanceDateString = "";
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryInventoryListModel : NSObject
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *beginDateString;//开始时间
@property (nonatomic, copy) NSString *subject;//盘点主题
@property (nonatomic, copy) NSString *info_description;//盘点内容
@property (nonatomic, copy) NSString *inventoryUserId;//盘点用户的id
@property (nonatomic, copy) NSString *closedDateString;//结案时间(判断状态)

@end

NS_ASSUME_NONNULL_END
