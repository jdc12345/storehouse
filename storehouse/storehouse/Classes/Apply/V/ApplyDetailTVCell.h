//
//  ApplyDetailTVCell.h
//  storehouse
//
//  Created by 万宇 on 2018/9/20.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyDetailTVCell : UITableViewCell
@property(nonatomic,weak)UILabel *itemLabel;//事项
@property(nonatomic,weak)UILabel *itemContentLabel;//内容
@property(nonatomic,weak)UITextField *contentField;//审批中状态备注
@end
