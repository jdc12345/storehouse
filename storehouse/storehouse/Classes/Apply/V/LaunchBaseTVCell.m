//
//  LaunchBaseTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/7/23.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchBaseTVCell.h"
#import "UILabel+Addition.h"

@implementation LaunchBaseTVCell

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
        make.centerY.equalTo(self.contentView.mas_top).offset(17.5*kiphone6H);
        make.left.offset(15*kiphone6);
        make.width.offset(60*kiphone6);
    }];
    self.itemLabel = itemLabel;
    //内容textfiled
    UITextField *conentField = [[UITextField alloc]init];
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
        make.centerY.equalTo(self.contentView.mas_top).offset(17.5*kiphone6H);
        make.left.equalTo(itemLabel.mas_right).offset(11*kiphone6);
        make.right.offset(-31*kiphone6);
        make.height.offset(35*kiphone6H);
    }];
    self.contentField = conentField;
    //列表按钮
    UIButton *listButton = [[UIButton alloc]init];
    [listButton setImage:[UIImage imageNamed:@"list_swich"] forState:UIControlStateNormal];
    listButton.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
    listButton.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
    listButton.layer.borderWidth = 1;
    [conentField addSubview:listButton];
    [listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(25*kiphone6);
    }];
    self.listButton = listButton;
    self.listButton.hidden = true;
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
