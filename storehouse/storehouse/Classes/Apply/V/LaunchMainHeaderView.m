//
//  LaunchMainHeaderView.m
//  storehouse
//
//  Created by 万宇 on 2018/6/12.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchMainHeaderView.h"
#import "LaunchMainHeaderButtonView.h"

@interface LaunchMainHeaderView()

@property (nonatomic, strong) LaunchMainHeaderButtonView* approvalView;//审批中
@property (nonatomic, strong) LaunchMainHeaderButtonView* rejectView;//被驳回
@property (nonatomic, strong) LaunchMainHeaderButtonView* confirmView;//已完成
@property (nonatomic, strong) LaunchMainHeaderButtonView* lossView;//已失效

@property (nonatomic, copy) void(^clickApprovalBlock)(void);
@property (nonatomic, copy) void(^clickRejectBlock)(void);
@property (nonatomic, copy) void(^clickConfirmBlock)(void);
@property (nonatomic, copy) void(^clickLossBlock)(void);

@end

@implementation LaunchMainHeaderView

- (void) setClickApprovalBlock:(void(^)(void))clickApprovalBlock
              clickRejectBlock:(void(^)(void))clickRejectBlock
             clickConfirmBlock:(void(^)(void))clickConfirmBlock
                clickLossBlock:(void(^)(void))clickLossBlock
{
    _clickApprovalBlock = clickApprovalBlock;
    _clickRejectBlock = clickRejectBlock;
    _clickConfirmBlock = clickConfirmBlock;
    _clickLossBlock = clickLossBlock;
}

- (void)setIsHaveRegectRedPoint:(BOOL)isHaveRegectRedPoint
{
    _isHaveRegectRedPoint = isHaveRegectRedPoint;
    _rejectView.isHiddenRedTipPoint = !isHaveRegectRedPoint;
}

- (void)setIsHaveStopRedPoint:(BOOL)isHaveStopRedPoint
{
    _isHaveStopRedPoint = isHaveStopRedPoint;
    _lossView.isHiddenRedTipPoint = !isHaveStopRedPoint;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _approvalView = [[LaunchMainHeaderButtonView alloc] init];
        _approvalView.type = LaunchMainHeaderButtonTypeApproval;
        [_approvalView addTarget:self action:@selector(clickApprovalBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_approvalView];
        
        _rejectView = [[LaunchMainHeaderButtonView alloc] init];
        _rejectView.type = LaunchMainHeaderButtonTypeReject;
        [_rejectView addTarget:self action:@selector(clickRejectBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rejectView];
        
        _confirmView = [[LaunchMainHeaderButtonView alloc] init];
        _confirmView.type = LaunchMainHeaderButtonTypeConfirm;
        [_confirmView addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmView];
        
        _lossView = [[LaunchMainHeaderButtonView alloc] init];
        _lossView.type = LaunchMainHeaderButtonTypeLoss;
        [_lossView addTarget:self action:@selector(clickLossBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_lossView];
        
        [_approvalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
        }];
        
        [_rejectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_approvalView.mas_right);
            make.top.bottom.width.equalTo(_approvalView);
        }];
        
        [_confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rejectView.mas_right);
            make.top.bottom.width.equalTo(_approvalView);
        }];
        
        [_lossView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_confirmView.mas_right);
            make.top.bottom.width.equalTo(_approvalView);
            make.right.equalTo(self);
        }];
        
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return self;
}
#pragma mark - 按钮点击

- (void)clickApprovalBtn
{
    if (self.clickApprovalBlock) {
        self.clickApprovalBlock();
    }
}

- (void)clickRejectBtn
{
    if (self.clickRejectBlock) {
        self.clickRejectBlock();
    }
}

- (void)clickConfirmBtn
{
    if (self.clickConfirmBlock) {
        self.clickConfirmBlock();
    }
}

- (void)clickLossBtn
{
    if (self.clickLossBlock) {
        self.clickLossBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
