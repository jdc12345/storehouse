//
//  HistoryInventoryListModel.m
//  storehouse
//
//  Created by 万宇 on 2018/12/10.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "HistoryInventoryListModel.h"

@implementation HistoryInventoryListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
@end
