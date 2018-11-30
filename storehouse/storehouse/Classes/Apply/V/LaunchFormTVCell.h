//
//  LaunchFormTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/7/31.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "storeThingsModel.h"

typedef void (^ifSelectedBlock)(storeThingsModel *selModel , BOOL btnSelected);
@interface LaunchFormTVCell : UITableViewCell
//block传递选中cell的model:
@property(nonatomic,copy) ifSelectedBlock ifSelectedBlock;
@property(nonatomic,weak)UIButton *selBtn;//选择按钮
@property(nonatomic,weak)UIView *selView;//选择视图
@property(nonatomic,weak)storeThingsModel *storeThingModel;//传递过来的库房列表物品数据model
@property(nonatomic,weak)storeThingsModel *selectedThingsModel;//传递过来的已选中库房列表物品数据model
@property(nonatomic,weak)UITextField *contentField;//资产数量
@end
