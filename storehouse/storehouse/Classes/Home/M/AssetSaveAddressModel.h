//
//  AssetSaveAddressModel.h
//  storehouse
//
//  Created by 万宇 on 2018/11/21.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetSaveAddressModel : NSObject
@property (nonatomic, copy) NSString* treeCode;//分类编码
@property (nonatomic, strong) NSArray* children;//子类
@property (nonatomic, copy) NSString* text;//类别名称
@end

NS_ASSUME_NONNULL_END
