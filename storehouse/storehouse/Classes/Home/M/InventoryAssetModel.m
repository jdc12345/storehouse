//
//  InventoryAssetModel.m
//  storehouse
//
//  Created by 万宇 on 2018/12/12.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "InventoryAssetModel.h"

@implementation InventoryAssetModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
@end