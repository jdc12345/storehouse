//
//  CPXApprovalCellLabel.h
//  ChuPinXiu
//
//  Created by 1 on 15/11/19.
//  Copyright © 2015年 chupinxiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPXCommonLabel : UILabel

/**
 *  创建Label 字体大小 字体颜色
 *
 *  @param font  字体大小
 *  @param color 字体颜色
 *
 *  @return UILabel
 */
+ (instancetype)commonLabelWithTitleFont:(UIFont*)font
                              andTextColor:(UIColor*)color;

/// 粗体文字
+(instancetype)commonBoldLabelWithTitleFont:(UIFont *)font andTextColor:(UIColor *)color;

/**
 *  创建Label 文本 字体大小 字体颜色
 *
 *  @param title 文本
 *  @param font  字体大小
 *  @param color 字体颜色
 *
 *  @return 
 */
+ (instancetype)commonLabelWithTitle:(NSString*)title
                              textFont:(UIFont*)font
                             textColor:(UIColor*)color;

/// 粗体文字
+ (instancetype) commonBoldLabelWithTitle:(NSString *)title
                                 textFont:(UIFont *)font
                                textColor:(UIColor *)color;
/**
 *  创建Label - 带边框
 *
 *  @param title        文本
 *  @param font         字体大小
 *  @param color        字体颜色
 *  @param borderColor  边框颜色
 *  @param cornerRadius 边框圆角半径
 *  @param borderWidth  边框宽度
 *
 *  @return 
 */
+ (instancetype)commonLabelWithTitle:(NSString*)title
                              textFont:(UIFont*)font
                             textColor:(UIColor*)color
                           borderColor:(UIColor*)borderColor
                          cornerRadius:(CGFloat)cornerRadius
                           borderWidth:(CGFloat)borderWidth;

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
                      backGroundColor:(UIColor *)backGroundColor;

/**
 *  创建label 文字, 字体 字体颜色 圆角 圆角半径 背景色
 *
 *  @param title        文字
 *  @param font         字体
 *  @param color        字体颜色
 *  @param corners      圆角位置
 *  @param cornerRadius 圆角半径
 *  @param backColor    背景色
 *
 *  @return
 */
+ (instancetype) commonLabelWithTitle:(NSString *)title
                             textFont:(UIFont *)font
                            textColor:(UIColor *)color
                              corners:(UIRectCorner)corners
                         cornerRadius:(CGFloat)cornerRadius
                            backColor:(UIColor *)backColor;
@end
