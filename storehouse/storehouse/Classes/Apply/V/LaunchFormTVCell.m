//
//  LaunchFormTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/7/31.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchFormTVCell.h"
#import "UILabel+Addition.h"
@interface LaunchFormTVCell()

@end
@implementation LaunchFormTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    //空白格
    UIButton *emptyBtn = [[UIButton alloc]init];
    emptyBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:emptyBtn];
    [emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.width.offset(35);
    }];
    [emptyBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //空白格的小方块
    UIView *selView = [[UIView alloc]init];
    [selView setBackgroundColor:[UIColor whiteColor]];
    selView.layer.borderColor = [UIColor colorWithHexString:@"373a41"].CGColor;
    selView.layer.borderWidth = 1;
    [emptyBtn addSubview:selView];
    [selView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.width.height.offset(5);
        make.left.offset(10);
    }];
    self.selView = selView;
    //序号label
    UILabel *numLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [emptyBtn addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyBtn);
        make.left.equalTo(selView.mas_right).offset(5);
    }];
    self.numLabel = numLabel;
    //申请部门label
    UILabel *departmentLabel = [UILabel labelWithText:@"申请部门" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    departmentLabel.backgroundColor = [UIColor whiteColor];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyBtn);
        make.left.equalTo(emptyBtn.mas_right);
        make.width.offset(100);
        make.height.offset(35);
    }];
    //申请人label
    UILabel *ApplicantLabel = [UILabel labelWithText:@"申请人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    ApplicantLabel.backgroundColor = [UIColor whiteColor];
    ApplicantLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:ApplicantLabel];
    [ApplicantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyBtn);
        make.left.equalTo(departmentLabel.mas_right);
        make.width.offset(100);
        make.height.offset(35);
    }];
    //物品名称label
    UILabel *goodsNameLabel = [UILabel labelWithText:@"物品名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    goodsNameLabel.backgroundColor = [UIColor whiteColor];
    goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyBtn);
        make.left.equalTo(ApplicantLabel.mas_right);
        make.width.offset(kScreenW-235);
        make.height.offset(35);
    }];
    [self layoutIfNeeded];
    [self setBorderWithView:emptyBtn top:false left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:departmentLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:ApplicantLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:goodsNameLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
}
//选中按钮点击事件
- (void)selBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selView.backgroundColor = [UIColor colorWithHexString:@"373a41"];
    }else{
        self.selView.backgroundColor = [UIColor whiteColor];
    }
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
