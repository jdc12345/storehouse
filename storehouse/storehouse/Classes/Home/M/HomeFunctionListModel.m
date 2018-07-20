//
//  HomeFunctionListModel.m
//  storehouse
//
//  Created by 万宇 on 2018/6/5.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "HomeFunctionListModel.h"

@implementation HomeFunctionListModel
+ (instancetype)itemWithDict:(NSDictionary *)dict{
    
    HomeFunctionListModel *model = [[HomeFunctionListModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
