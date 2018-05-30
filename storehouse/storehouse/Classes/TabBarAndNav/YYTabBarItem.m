//
//  YYTabBarItem.m
//  钱到到
//
//  Created by aki on 16/3/8.
//  Copyright © 2016年 AKI. All rights reserved.
//

#import "YYTabBarItem.h"

//static CGFloat kImageScale = 0.78f;

@implementation YYTabBarItem

#pragma mark -
#pragma mark lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置文字字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        // 设置文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 调整图片
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

// 调整文字的frame  contentRect：button的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat pointX = 0;
    CGFloat pointY = contentRect.size.height * _kImageScale - _titleLabelHigh;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * (1 - _kImageScale);
    return CGRectMake(pointX, pointY, width, height);
}

// 调整图片的frame  contentRect：button的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * _kImageScale;
    return CGRectMake(pointX, pointY, width, height);
}

@end
