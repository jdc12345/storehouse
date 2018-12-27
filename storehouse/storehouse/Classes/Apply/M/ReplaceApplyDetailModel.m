//
//  ReplaceApplyDetailModel.m
//  storehouse
//
//  Created by 万宇 on 2018/12/27.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "ReplaceApplyDetailModel.h"

@implementation ReplaceApplyDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id",@"info_newAssetId" : @"newAssetId",@"info_newAssetName" : @"newAssetName"};
}
@end
