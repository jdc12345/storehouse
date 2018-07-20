//
//  LaunchMainHeaderView.h
//  storehouse
//
//  Created by 万宇 on 2018/6/12.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchMainHeaderView : UIView

@property (nonatomic,assign) BOOL                isHaveRegectRedPoint;
@property (nonatomic,assign) BOOL                isHaveStopRedPoint;

- (void) setClickApprovalBlock:(void(^)(void))clickApprovalBlock
              clickRejectBlock:(void(^)(void))clickRejectBlock
             clickConfirmBlock:(void(^)(void))clickConfirmBlock
                clickLossBlock:(void(^)(void))clickLossBlock;

@end
