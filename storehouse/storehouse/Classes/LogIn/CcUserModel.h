//
//  CcUserModel.h
//  storehouse
//
//  Created by 万宇 on 2018/8/2.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "permissionTypeModel.h"

@interface CcUserModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *userName;//用户名(昵称)
@property (nonatomic, strong) NSString *trueName;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *gender;//性别
@property (nonatomic, strong) NSString *idCard;//身份证号
@property (nonatomic, strong) NSString *origin;//籍贯
@property (nonatomic, strong) NSString *marital;//婚姻状况
@property (nonatomic, strong) NSString *avatar;//头像
@property (nonatomic, strong) NSString *createTime;//注册时间
@property (nonatomic, strong) NSString *telephone;//电话号码
@property (nonatomic, strong) NSString *mobile;//手机号码
@property (nonatomic, strong) NSString *loginName;//登录名
@property (nonatomic, strong) NSString *password;//登录密码
@property (nonatomic, strong) NSString *email;//Email
@property (nonatomic, strong) NSString *status;//用户状态
@property (nonatomic, strong) NSString *groupId;//用户组编号
@property (nonatomic, strong) NSString *departmentCode;//部门编码
@property (nonatomic, strong) NSString *departmentName;//部门名称
@property (nonatomic, strong) NSArray *permission;
@property (nonatomic, strong) NSString *userCookie;//登录请求的cookies


+ (CcUserModel *)defaultClient;
- (void)saveAllInfo;
- (void)removeUserInfo;
@end
