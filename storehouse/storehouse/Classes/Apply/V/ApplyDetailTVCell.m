//
//  ApplyDetailTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/9/20.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "ApplyDetailTVCell.h"
#import "UILabel+Addition.h"

@implementation ApplyDetailTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    //事项label
    UILabel *itemLabel = [UILabel labelWithText:@"申请部门" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    self.itemLabel = itemLabel;
    //事项内容label
    UILabel *itemContentLabel = [UILabel labelWithText:@"申请部门" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [self.contentView addSubview:itemContentLabel];
    [itemContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(itemLabel);
        make.left.offset(95);
    }];
    self.itemContentLabel = itemContentLabel;
    //内容textfiled
    UITextField *conentField = [[UITextField alloc]init];
    conentField.returnKeyType = UIReturnKeyDone;
    //设置左边视图的宽度
    
    conentField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 9, 0)];
    conentField.font = [UIFont systemFontOfSize:12];
    conentField.textColor = [UIColor colorWithHexString:@"373a41"];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    
    conentField.leftViewMode = UITextFieldViewModeAlways;
    conentField.backgroundColor = [UIColor whiteColor];
    conentField.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
    conentField.layer.borderWidth = 1;
    [self.contentView addSubview:conentField];
    [conentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-1);
        make.left.offset(95);
        make.right.offset(-31);
        make.height.offset(35);
    }];
    conentField.hidden = true;//默认隐藏，当处于审批中状态时显示
    self.contentField = conentField;
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
