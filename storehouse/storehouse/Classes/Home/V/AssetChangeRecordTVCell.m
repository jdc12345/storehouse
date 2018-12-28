//
//  AssetChangeRecordTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/12/28.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "AssetChangeRecordTVCell.h"
#import "UILabel+Addition.h"
@interface AssetChangeRecordTVCell()
@property(nonatomic,weak)UILabel *changedateLabel;//变动日期
@property(nonatomic,weak)UILabel *itemLabel;//变动事项
@property(nonatomic,weak)UILabel *saveUserLabel;//关联人
@end
@implementation AssetChangeRecordTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //ui
        [self setupUI];
    }
    return self;
}
-(void)setModel:(AssetChangeRecordModel *)model{
    _model = model;
    self.changedateLabel.text = model.changeDateString;
    self.itemLabel.text = model.changeDesc;
    self.saveUserLabel.text = model.saveUserName;

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
    //变动日期label
    UILabel *changeDateLabel = [UILabel labelWithText:@"变动日期" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    changeDateLabel.backgroundColor = [UIColor whiteColor];
    changeDateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:changeDateLabel];
    [changeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(numLabel.mas_right);
        make.width.offset(120);
        make.height.offset(35);
    }];
    self.changedateLabel = changeDateLabel;
    //变动事项label
    UILabel *itemLabel = [UILabel labelWithText:@"变动事项" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    itemLabel.backgroundColor = [UIColor whiteColor];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(changeDateLabel.mas_right);
        make.width.offset(120);
        make.height.offset(35);
    }];
    self.itemLabel = itemLabel;
    //保管人label
    UILabel *saveUserLabel = [UILabel labelWithText:@"保管人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    saveUserLabel.backgroundColor = [UIColor whiteColor];
    saveUserLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:saveUserLabel];
    [saveUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(itemLabel.mas_right);
        make.width.offset(kScreenW - 280);
        make.height.offset(35);
    }];
    self.saveUserLabel = saveUserLabel;
    
    [self.contentView layoutIfNeeded];
    [self setBorderWithView:numLabel top:false left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:changeDateLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:itemLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:saveUserLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
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

