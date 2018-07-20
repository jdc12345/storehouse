//
//  LaunchMainHeaderButtonView.m
//  storehouse
//
//  Created by 万宇 on 2018/6/6.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchMainHeaderButtonView.h"
#import "CPXCommonLabel.h"

@interface LaunchMainHeaderButtonView()

@property (nonatomic, strong) UIImageView   * imgV;
@property (nonatomic, strong) UILabel       * titleLabel;
@property (nonatomic, strong) UIImageView   * redImgV;

@end

@implementation LaunchMainHeaderButtonView
//通知红点赋值
- (void)setIsHiddenRedTipPoint:(BOOL)isHiddenRedTipPoint
{
    _isHiddenRedTipPoint = isHiddenRedTipPoint;
    _redImgV.hidden = isHiddenRedTipPoint;
}
- (void)setType:(LaunchMainHeaderButtonType)type
{
    _type = type;
    switch (type) {
        case LaunchMainHeaderButtonTypeApproval:
            _titleLabel.text = @"审批中";
            _imgV.image = [UIImage imageNamed:@"approval_ing"];
//            [_imgV setHighlightedImage:[UIImage imageNamed:@"审批中按压"]];
            break;
        case LaunchMainHeaderButtonTypeReject:
            _titleLabel.text = @"被驳回";
            _imgV.image = [UIImage imageNamed:@"approval_reject"];
//            [_imgV setHighlightedImage:[UIImage imageNamed:@"被驳回按压"]];
            break;
        case LaunchMainHeaderButtonTypeConfirm:
            _titleLabel.text = @"已完成";
            _imgV.image = [UIImage imageNamed:@"approval_confirm"];
//            [_imgV setHighlightedImage:[UIImage imageNamed:@"已完成按压"]];
            break;
        case LaunchMainHeaderButtonTypeLoss:
            _titleLabel.text = @"已失效";
            _imgV.image = [UIImage imageNamed:@"approval_loss"];
//            [_imgV setHighlightedImage:[UIImage imageNamed:@"已失效按压"]];
            break;
        default:
            break;
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        _titleLabel = [CPXCommonLabel commonLabelWithTitle:@"" textFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"2face4"]];
        [_titleLabel setHighlightedTextColor:[UIColor colorWithWhite:1.0 alpha:0.66]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _redImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的审批-消息提示"]];
        _redImgV.hidden = YES;
        [self addSubview:_redImgV];
        
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(3*kiphone6H);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(9*kiphone6H);
        }];
        
        [_redImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgV.mas_right).offset(-5);
            make.bottom.equalTo(_imgV.mas_top).offset(5);
            make.width.height.mas_equalTo(13);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.imgV.highlighted = highlighted;
    self.titleLabel.highlighted = highlighted;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
