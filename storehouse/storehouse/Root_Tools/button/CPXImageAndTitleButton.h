//
//  CPXImageAndTitleButton.h
//  ChuPinXiu
//
//  Created by cpx on 16/1/20.
//  Copyright © 2016年 chupinxiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CPXImageAndTitleButtonImagePosition) {
    CPXImageAndTitleButtonImagePositionUp = 0,   // 图片在上
    CPXImageAndTitleButtonImagePositionDown,     // 图片在下
    CPXImageAndTitleButtonImagePositionLeft,     // 图片在左
    CPXImageAndTitleButtonImagePositionRight     // 图片在右
};

@interface CPXImageAndTitleButton : UIButton
/**
 *  图片icon
 */
@property (nonatomic, assign)CPXImageAndTitleButtonImagePosition imagePosition;

/**
 *  图片和标题间距
 */
@property (nonatomic, assign)CGFloat                             imageAndTitleOffset;

@end
