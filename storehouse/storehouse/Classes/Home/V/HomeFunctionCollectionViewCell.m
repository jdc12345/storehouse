//
//  HomeFunctionCollectionViewCell.m
//  storehouse
//
//  Created by 万宇 on 2018/6/5.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "HomeFunctionCollectionViewCell.h"
@interface HomeFunctionCollectionViewCell ()

@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;

@end
@implementation HomeFunctionCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}
-(void)setFunctionListModel:(HomeFunctionListModel *)functionListModel{
    _functionListModel = functionListModel;
    // 把数据放在控件上
    self.iconView.image = [UIImage imageNamed:functionListModel.icon];
    self.nameLabel.text = functionListModel.name;
}

- (void)setupUI
{
    // 设置整个cell的背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    // 创建子控件
    UIImageView* iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"housekeeping"];
    [self.contentView addSubview:iconView];
    //    CALayer *layer = [iconView layer];
    //    layer.shadowOffset = CGSizeMake(0, 3);
    //    layer.shadowRadius = 5.0;
    //    layer.shadowColor = [UIColor blackColor].CGColor;
    //    layer.shadowOpacity = 0.8;
    
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor colorWithHexString:@"373a41"];
    nameLabel.text = @"扫一扫";
    [self.contentView addSubview:nameLabel];
    
    // 自动布局
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.contentView);
        make.top.offset(13*kiphone6H);
//        make.width.height.offset(47*kiphone6);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(iconView.mas_bottom).offset(4*kiphone6H);
        make.centerX.equalTo(iconView);
    }];
    
    self.iconView = iconView;
    self.nameLabel = nameLabel;
}

@end
