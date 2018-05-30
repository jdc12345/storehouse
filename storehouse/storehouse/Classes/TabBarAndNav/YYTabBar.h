//
//  YYTabBar.h
//  钱到到
//
//  Created by aki on 16/3/8.
//  Copyright © 2016年 AKI. All rights reserved.
//

/**
 *  自定义TabBar
 */

#import <UIKit/UIKit.h>

typedef void(^YYTabBarBlock)(NSUInteger index);

@interface YYTabBar : UITabBar

+ (instancetype)initWithTabs:(NSInteger)count systemTabBarHeight:(CGFloat)height selected:(YYTabBarBlock)selectedBlock;

- (void)setTabAtIndex:(NSInteger)index title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage;

-(void)selectTab:(NSInteger)index;

@end
