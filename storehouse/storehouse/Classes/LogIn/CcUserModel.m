//
//  CcUserModel.m
//  storehouse
//
//  Created by 万宇 on 2018/8/2.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "CcUserModel.h"

@implementation CcUserModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
+ (CcUserModel *)defaultClient{
    static CcUserModel *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[self alloc]init];
    });
    [userModel setUserModelInfo];
    return userModel;
}
// telephoneNum

- (void)saveAllInfo{
    [[NSUserDefaults standardUserDefaults] setValue:self.info_id forKey:@"info_id"];
    [[NSUserDefaults standardUserDefaults] setValue:self.avatar forKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] setValue:self.loginName forKey:@"loginName"];
    [[NSUserDefaults standardUserDefaults] setValue:self.password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setValue:self.gender forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setValue:self.age forKey:@"age"];
    [[NSUserDefaults standardUserDefaults] setValue:self.createTime forKey:@"createTime"];
    [[NSUserDefaults standardUserDefaults] setValue:self.mobile forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] setValue:self.userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setValue:self.trueName forKey:@"trueName"];
    [[NSUserDefaults standardUserDefaults] setValue:self.status forKey:@"status"];
    [[NSUserDefaults standardUserDefaults] setValue:self.telephone forKey:@"telephone"];
    [[NSUserDefaults standardUserDefaults] setValue:self.marital forKey:@"marital"];
    [[NSUserDefaults standardUserDefaults] setValue:self.userCookie forKey:@"userCookie"];
    [[NSUserDefaults standardUserDefaults] setValue:self.departmentCode forKey:@"departmentCode"];
    [[NSUserDefaults standardUserDefaults] setValue:self.departmentName forKey:@"departmentName"];
    //偏好设置存储数组字典需要转化为数据再存储
    NSData *permissionData = [NSJSONSerialization dataWithJSONObject:self.permission options:NSJSONWritingPrettyPrinted error:nil];
    [[NSUserDefaults standardUserDefaults] setValue:permissionData forKey:@"permission"];
}
- (void)setUserModelInfo{
    self.info_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"info_id"];
    self.avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    self.loginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"];
    self.gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    self.password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    self.age = [[NSUserDefaults standardUserDefaults] objectForKey:@"age"];
    self.createTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"createTime"];
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    self.trueName = [[NSUserDefaults standardUserDefaults] objectForKey:@"trueName"];
    self.telephone = [[NSUserDefaults standardUserDefaults] objectForKey:@"telephone"];
    self.mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    self.status = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    self.marital = [[NSUserDefaults standardUserDefaults] objectForKey:@"marital"];
    self.userCookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCookie"];
    self.departmentCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"departmentCode"];
    self.departmentName = [[NSUserDefaults standardUserDefaults] objectForKey:@"departmentName"];
//    将NSData转换成(NSString, NSArray)
    NSData *permissionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"permission"];
    if (permissionData) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:permissionData options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = (NSArray *)jsonObject; // 或者 NSString *string = (NSString *)jsonObject;
        self.permission = array;
    }
//    self.permission = [[NSUserDefaults standardUserDefaults] objectForKey:@"permission"];
}
- (void)removeUserInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"info_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"age"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"createTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"telephone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"status"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"trueName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"marital"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userCookie"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"departmentCode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"departmentName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"permission"];
    
}
@end
