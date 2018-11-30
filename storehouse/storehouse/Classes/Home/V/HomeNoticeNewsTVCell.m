//
//  HomeNoticeNewsTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/6/6.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "HomeNoticeNewsTVCell.h"
#import "UILabel+Addition.h"

@interface HomeNoticeNewsTVCell()
@property (nonatomic, weak) UIImageView* typeImage;
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@end
@implementation HomeNoticeNewsTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
-(void)setModel:(HomePageNoticeModel *)model{
    _model = model;
    self.timeLabel.text = model.createTimeString;
    self.itemLabel.text = model.title;
}
-(void)setupUI{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    UIImageView *typeImage = [[UIImageView alloc]init];//类型图片
    typeImage.image = [UIImage imageNamed:@"home_news"];
    [self.contentView addSubview:typeImage];
    UILabel *itemLabel = [UILabel labelWithText:@"今天下午全院盘点" andTextColor:[UIColor colorWithHexString:@"374a41"] andFontSize:12];//具体通知事项
     itemLabel.numberOfLines = 0;
    [self.contentView addSubview:itemLabel];
    UILabel *timeLabel = [UILabel labelWithText:@"2018年5月2日" andTextColor:[UIColor colorWithHexString:@"374a41"] andFontSize:12];//通知时间
    [self.contentView addSubview:timeLabel];
    //约束
    [typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kiphone6H);
        make.centerY.offset(0);
    }];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeImage.mas_right).offset(32*kiphone6);
        make.centerY.offset(0);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15*kiphone6);
        make.centerY.offset(0);
    }];
    
    self.itemLabel = itemLabel;
    self.timeLabel = timeLabel;
    self.typeImage = typeImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
