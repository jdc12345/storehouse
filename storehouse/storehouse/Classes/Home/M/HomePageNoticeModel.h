//
//  HomePageNoticeModel.h
//  storehouse
//
//  Created by 万宇 on 2018/11/20.
//  Copyright © 2018 wanyu. All rights reserved.
//
//content = "\U6d4b\U8bd5\U901a\U77e5\U5185\U5bb9";
//createTimeString = "2018-11-20 10:43:29";
//deleteTime = "<null>";
//id = 1;
//isDelete = 0;
//isRead = 0;
//msgStatus = 0;
//msgType = 0;
//referId = 0;
//status = 1;
//title = "\U6d4b\U8bd5\U901a\U77e5\U6807\U9898";
//toUserId = 0;
//updateTimeString = "";
//userId = 0;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageNoticeModel : NSObject
@property (nonatomic, copy) NSString* info_id;
@property (nonatomic, copy) NSString* title;//标题
@property (nonatomic, copy) NSString* content;//内容
@property (nonatomic, copy) NSString* createTimeString;//发出时间
@property (nonatomic, assign) BOOL isRead;//是否已读
@end

NS_ASSUME_NONNULL_END
