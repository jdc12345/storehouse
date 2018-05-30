//
//  YYTabBar.m
//  钱到到
//
//  Created by aki on 16/3/8.
//  Copyright © 2016年 AKI. All rights reserved.
//

#import "YYTabBar.h"
#import "YYTabBarItem.h"
//#import "Pallete.h"
//#import "Dimension.h"
//#import "ScreenUtil.h"
//#import "ImageUtil.h"
#import "UIColor+Extension.h"
/** btn的tag值 */
static NSUInteger kTag = 1000;

@interface YYTabBar ()

@property (nonatomic) NSInteger tabCount;

/** 全局button */
@property (nonatomic, strong) UIButton *selectedBtn;
/** blockn */
@property (nonatomic, copy) YYTabBarBlock block;

@end

@implementation YYTabBar

#pragma mark - initmethods
+ (instancetype)initWithTabs:(NSInteger)count systemTabBarHeight:(CGFloat)height selected:(YYTabBarBlock)selectedBlock {
    CGFloat tabBarHeight = 55;
    YYTabBar *tabBar = [[YYTabBar alloc] initWithFrame:CGRectMake(0, - (tabBarHeight - height), kScreenW, tabBarHeight)];
    tabBar.tabCount = count;
    tabBar.block = selectedBlock;
    
//    [tabBar setBackgroundImage:[ImageUtil gradientImageWithColors:[NSArray arrayWithObjects:[UIColor colorWithHexString:@"F3F4F6"],[UIColor colorWithHexString:@"F3F4F6"], nil] withSize:tabBar.frame.size]];
    [tabBar setShadowImage:[UIImage new]];
    
    /** 获取button的宽度 */
    CGFloat tabBarItemWidth = kScreenW / count ;
    /** 设置背景颜色 */
    tabBar.backgroundColor = [UIColor clearColor];
    
    for (NSUInteger idx = 0; idx < count; idx++) {
        /** 获取btn的X坐标 */
        CGFloat pointX = tabBarItemWidth * idx;
        /** 初始化一个btn */
        YYTabBarItem *btn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
        /** 设置frame */
        btn.frame = CGRectMake(pointX, 0, tabBarItemWidth, CGRectGetHeight(tabBar.frame));
        btn.kImageScale = 0.72f;
        btn.titleLabelHigh = 8;
        
        /** 设置文字颜色 */
        [btn setTitleColor:[UIColor colorWithHexString:@"656D78"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"B1B8C3"] forState:UIControlStateSelected];
        
        /** 添加事件响应 */
        [btn addTarget:tabBar action:@selector(tabDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        /** 设置tag */
        btn.tag = kTag + idx;
        
        /** 第一个按钮默认选中 */
        if (!idx) {
            tabBar.selectedBtn = btn;
            btn.selected = YES;
        }
        
        [tabBar addSubview:btn];
    }
    /*
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -[Dimension commonTabBarShadowHeight], tabBar.frame.size.width, [Dimension commonTabBarShadowHeight])];
    
    // Add gradient layer
    CAGradientLayer *shadowLayer = [CAGradientLayer layer];
    shadowLayer.frame = shadowView.bounds;
    shadowLayer.colors = [NSArray arrayWithObjects:(id)[Pallete colorWithHexString:@"000000" alpha:0].CGColor, (id)[Pallete colorWithHexString:@"000000" alpha:0.1].CGColor, nil];
    shadowLayer.startPoint = CGPointMake(0.0, 0.0);
    shadowLayer.endPoint = CGPointMake(0.0, 1.0);
    
    [shadowView.layer addSublayer:shadowLayer];
    [tabBar addSubview:shadowView];
     */
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"E6E9ED"];
    [tabBar addSubview:line];
    
    return tabBar;
}

- (void)setTabAtIndex:(NSInteger)index title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    YYTabBarItem *tabBarItem = self.subviews[index];
    
    [tabBarItem setTitle:title forState:UIControlStateNormal];
    [tabBarItem setTitleColor:[UIColor colorWithHexString:@"aaa9a9"] forState:UIControlStateNormal];
    [tabBarItem setTitleColor:[UIColor colorWithHexString:@"25f368"] forState:UIControlStateSelected];

    [tabBarItem setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [tabBarItem setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
}

#pragma mark - view methods
- (CGSize)sizeThatFits:(CGSize)size {
    [super sizeThatFits:size];
    return CGSizeMake(kScreenW, 55);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

#pragma mark - Actions
-(void)selectTab:(NSInteger)index {
    UIButton *btn = [self viewWithTag:kTag +index];
    /** 把以前选中的button设置为不选中 */
    self.selectedBtn.selected = NO;
    /** 把当前选中的button设置为选中 */
    btn.selected = YES;
    /** 把当前选中的button赋值给全局button */
    self.selectedBtn = btn;
}

/** 按钮事件响应方法 */
- (void)tabDidSelected:(YYTabBarItem *)btn {
    [self selectTab:(btn.tag - kTag)];
    
    /** block */
    if (self.block) {
        self.block(btn.tag - kTag);
    }
}

@end
