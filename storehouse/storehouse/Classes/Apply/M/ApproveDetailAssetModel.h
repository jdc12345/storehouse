//
//  ApproveDetailAssetModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/16.
//  Copyright © 2018 wanyu. All rights reserved.
///assetsId = 1;
//assetsName = "\U7535\U8111";
//categoryCode = 01;
//categoryName = "\U529e\U516c\U7528\U54c1";
//createTimeString = "";
//documentMaker = 0;
//id = 207;
//num = 2;
//recipientsId = 46;
//recipientsName = "";
//status = 1;
//totalNum = 2;
//updateTimeString = "";
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApproveDetailAssetModel : NSObject
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *assetsId;
@property (nonatomic, copy) NSString *recipientsId;
@property (nonatomic, copy) NSString *num;//实际数量
@property (nonatomic, copy) NSString *totalNum;//申请数量
@property (nonatomic, copy) NSString *categoryName;//分类名称
@property (nonatomic, copy) NSString *assetsName;//资产名称
@property (nonatomic, copy) NSString *rejectReason;//审批备注
@end

NS_ASSUME_NONNULL_END
