//
//  LaunchTypeModel.m
//  storehouse
//
//  Created by 万宇 on 2018/12/17.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchTypeModel.h"

@implementation LaunchTypeModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
@end