//
//  HomeFunctionListModel.h
//  storehouse
//
//  Created by 万宇 on 2018/6/5.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeFunctionListModel : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* icon;
+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end
