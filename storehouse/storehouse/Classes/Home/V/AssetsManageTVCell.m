//
//  AssetsManageTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/11/18.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "AssetsManageTVCell.h"
#import "UILabel+Addition.h"
@interface AssetsManageTVCell()
@property(nonatomic,weak)UILabel *assetNumLabel;//资产数量
@property(nonatomic,weak)UILabel *storePlacelabel;//保存地
@property(nonatomic,weak)UILabel *assetNameLabel;//资产名称
@property(nonatomic,weak)UILabel *keeperLabel;//保管人label
@end
@implementation AssetsManageTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //ui
        [self setupUI];
    }
    return self;
}
-(void)setAssetModel:(AssetModel *)assetModel{
    _assetModel = assetModel;
    self.assetNumLabel.text = assetModel.num;
    self.assetNameLabel.text = assetModel.assetName;
    self.keeperLabel.text = assetModel.saveUserName;
    self.storePlacelabel.text = assetModel.addressName;
    
}
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    //序号
    UILabel *numLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(40);
        make.height.offset(35);
    }];
    self.numLabel = numLabel;
    //编号label
    UILabel *departmentLabel = [UILabel labelWithText:@"资产编码" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    departmentLabel.backgroundColor = [UIColor whiteColor];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(numLabel.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    self.assetNumLabel = departmentLabel;
    //物品名称label
    UILabel *goodsNameLabel = [UILabel labelWithText:@"资产名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    goodsNameLabel.backgroundColor = [UIColor whiteColor];
    goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(departmentLabel.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    self.assetNameLabel = goodsNameLabel;
    //保管人label
    UILabel *keeperLabel = [UILabel labelWithText:@"保管人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    keeperLabel.backgroundColor = [UIColor whiteColor];
    keeperLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:keeperLabel];
    [keeperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(goodsNameLabel.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    self.keeperLabel = keeperLabel;
    //storelabel
    UILabel *storelabel = [UILabel labelWithText:@"存放地" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    storelabel.backgroundColor = [UIColor whiteColor];
    storelabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:storelabel];
    [storelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(keeperLabel.mas_right);
        make.width.offset(kScreenW - 265);
        make.height.offset(35);
    }];
    self.storePlacelabel = storelabel;
    
    [self.contentView layoutIfNeeded];
    [self setBorderWithView:numLabel top:false left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:departmentLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:goodsNameLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:keeperLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:storelabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
}
//给view添加不同位置的边框
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
