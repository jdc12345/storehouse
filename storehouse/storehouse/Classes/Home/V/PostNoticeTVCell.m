//
//  PostNoticeTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/11/20.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "PostNoticeTVCell.h"
#import "UILabel+Addition.h"

@implementation PostNoticeTVCell

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
    UILabel *itemLabel = [UILabel labelWithText:@"通知标题" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_top).offset(17.5);
        make.left.offset(15);
        make.width.offset(60);
    }];
    self.itemLabel = itemLabel;
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
        make.centerY.equalTo(self.contentView.mas_top).offset(17.5);
        make.left.equalTo(itemLabel.mas_right).offset(11);
        make.right.offset(-31);
        make.top.offset(4.5);
        make.bottom.offset(-4.5);
    }];
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
