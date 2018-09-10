//
//  permissionTypeModel.h
//  storehouse
//
//  Created by 万宇 on 2018/8/9.
//  Copyright © 2018年 wanyu. All rights reserved.
//
//"status": 1,
//"createTime": null,
//"updateTime": null,
//"localId": null,
//"info": null,
//"id": 1,
//"moduleId": 1,
//"permissionName": "采购申请",
//"permissionType": 1,
//"target": "buyApply",
//"operaton": "*",
//"description": "全部权限",
//"controlLevel": 3,
//"moduleName": null,
//"createTimeString": null,
//"updateTimeString": null
#import <Foundation/Foundation.h>

@interface permissionTypeModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *permissionName;//权限名称
@property (nonatomic, strong) NSString *permissionType;//权限类型
@property (nonatomic, strong) NSString *descriptions;//权限描述
@property (nonatomic, strong) NSString *target;//权限码
@property (nonatomic, strong) NSString *operaton;//具体有哪些权限,*=全部权限，read=查看、查询，create=创建、添加，update=更新、修改，delete=删除

@end
