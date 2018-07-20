//
//  CPXApprovalCellLabel.m
//  ChuPinXiu
//
//  Created by 1 on 15/11/19.
//  Copyright © 2015年 chupinxiu. All rights reserved.
//

#import "CPXCommonLabel.h"

@implementation CPXCommonLabel

+(instancetype)commonLabelWithTitleFont:(UIFont *)font andTextColor:(UIColor *)color
{
    CPXCommonLabel *lbl = [[CPXCommonLabel alloc] init];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = color;
    lbl.font = font;
    return lbl;
}


/// 粗体文字
+(instancetype)commonBoldLabelWithTitleFont:(UIFont *)font andTextColor:(UIColor *)color
{
    CPXCommonLabel *lbl = [[CPXCommonLabel alloc] init];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = color;
    lbl.font = [UIFont boldSystemFontOfSize:font.pointSize];
    return lbl;
}


+ (instancetype) commonLabelWithTitle:(NSString *)title
                               textFont:(UIFont *)font
                              textColor:(UIColor *)color
{
    CPXCommonLabel *lbl = [[CPXCommonLabel alloc] init];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = title;
    lbl.font = font;
    lbl.textColor = color;
    lbl.numberOfLines = 0;
    [lbl sizeToFit];
    return lbl;
}


+ (instancetype) commonBoldLabelWithTitle:(NSString *)title
                             textFont:(UIFont *)font
                            textColor:(UIColor *)color
{
    CPXCommonLabel *lbl = [[CPXCommonLabel alloc] init];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = title;
    lbl.font = [UIFont boldSystemFontOfSize:font.pointSize];
    lbl.textColor = color;
    lbl.numberOfLines = 0;
    [lbl sizeToFit];
    return lbl;
}


+ (instancetype) commonLabelWithTitle:(NSString *)title
                               textFont:(UIFont *)font
                              textColor:(UIColor *)color
                            borderColor:(UIColor *)borderColor
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
{
    CPXCommonLabel *lbl = [CPXCommonLabel commonLabelWithTitle:title textFont:font textColor:color];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = font;
    lbl.text = title;
    lbl.textColor = color;
    lbl.layer.cornerRadius = cornerRadius;
    lbl.clipsToBounds = YES;
    lbl.layer.borderColor = borderColor.CGColor;
    lbl.layer.borderWidth = borderWidth;
    [lbl sizeToFit];
    lbl.textAlignment = NSTextAlignmentCenter;
    
    return lbl;
}
/**
 *  创建label 文字 字体大小 字体颜色 边框 背景色
 *
 *  @param title           文字
 *  @param font            字体大小
 *  @param color           字体颜色
 *  @param cornerRadius    边框弧度
 *  @param backGroundColor 背景色
 *
 *  @return
 */
+ (instancetype) commonLabelWithTitle:(NSString *)title
                             textFont:(UIFont *)font
                            textColor:(UIColor *)color
                         cornerRadius:(CGFloat)cornerRadius
                      backGroundColor:(UIColor *)backGroundColor
{
    CPXCommonLabel *lbl = [CPXCommonLabel commonLabelWithTitle:title textFont:font textColor:color];
    lbl.font = font;
    lbl.text = title;
    lbl.textColor = color;
    lbl.layer.cornerRadius = cornerRadius;
    lbl.clipsToBounds = YES;
    lbl.backgroundColor = backGroundColor;
//    lbl.textAlignment = NSTextAlignmentCenter;
    
    return lbl;
}

+ (instancetype) commonLabelWithTitle:(NSString *)title
                             textFont:(UIFont *)font
                            textColor:(UIColor *)color
                              corners:(UIRectCorner)corners
                         cornerRadius:(CGFloat)cornerRadius
                            backColor:(UIColor *)backColor
{
    CPXCommonLabel *lbl = [CPXCommonLabel commonLabelWithTitle:title textFont:font textColor:color];
    lbl.backgroundColor = backColor;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.layer.cornerRadius = cornerRadius;
    lbl.clipsToBounds = YES;
    return lbl;
}

@end
