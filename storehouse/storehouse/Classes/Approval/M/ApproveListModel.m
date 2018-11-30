//
//  ApproveListModel.m
//  storehouse
//
//  Created by 万宇 on 2018/9/11.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "ApproveListModel.h"

@implementation ApproveListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
@end
