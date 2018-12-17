//
//  LaunchTypeModel.h
//  storehouse
//
//  Created by 万宇 on 2018/12/17.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LaunchTypeModel : NSObject
@property (nonatomic, copy) NSString *applyType;//申请类型
@property (nonatomic, copy) NSString *typeName;//分类名称
@property (nonatomic, assign) BOOL isSelected;//是否选中
@end

NS_ASSUME_NONNULL_END
