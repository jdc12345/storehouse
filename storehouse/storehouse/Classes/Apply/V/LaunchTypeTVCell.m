//
//  LaunchTypeTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/8/15.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchTypeTVCell.h"
@interface LaunchTypeTVCell ()
@property(nonatomic,strong)UILabel *launchTypeLabel;//事项
@property (nonatomic,strong) UIImageView *selectedImageView;
@property (nonatomic,strong) UIView      *bottomLine;

//@property (nonatomic,assign) CPXLaunchTypeCellStyle cellStyle;

@end
@implementation LaunchTypeTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self setupUI];
    }
    return self;
}
-(void)setModel:(LaunchTypeModel *)model{
    _model = model;
    self.launchTypeLabel.text = model.typeName;
    if (model.isSelected) {
        self.selectedImageView.hidden = false;
    }else{
        self.selectedImageView.hidden = true;
    }
}
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    //底线
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xeaeaea"];
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(0.5);
    }];
    //类型label
    _launchTypeLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _launchTypeLabel.backgroundColor = [UIColor clearColor];
    _launchTypeLabel.font = [UIFont systemFontOfSize:12];
    _launchTypeLabel.textColor = [UIColor colorWithHexString:@"373a41"];
    _launchTypeLabel.textAlignment = NSTextAlignmentCenter;
    _launchTypeLabel.text = @"申请类型";
    [self addSubview:_launchTypeLabel];
    //选中对号
    _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的发起-选择类型"]];
    _selectedImageView.backgroundColor = [UIColor clearColor];
    [_selectedImageView sizeToFit];
    [self addSubview:_selectedImageView];
    [_selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-20);
        make.width.height.offset(40);
    }];
    
}
+ (CGFloat)cellHeight{
    return 48;
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
