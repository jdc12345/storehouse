//
//  ScrapApplyDetailModel.h
//  storehouse
//
//  Created by 万宇 on 2018/9/25.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrapApplyDetailModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *assetsName;//物品名称
@property (nonatomic, strong) NSString *userName;//申请人
@property (nonatomic, strong) NSString *comment;//报废理由
@property (nonatomic, strong) NSString *scrapModeId;//报废方式
@property (nonatomic, strong) NSString *scrapDateString;//所在位置
@property (nonatomic, strong) NSString *departmentName;//部门
@end
