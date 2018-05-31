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

@property (nonatomic,assign)UIEdgeInsets oldSafeAreaInsets;
@end

@implementation YYTabBar

#pragma mark - initmethods
+ (instancetype)initWithTabs:(NSInteger)count systemTabBarHeight:(CGFloat)height selected:(YYTabBarBlock)selectedBlock {
//    CGFloat tabBarHeight = 49;
//    YYTabBar *tabBar = [[YYTabBar alloc] initWithFrame:CGRectMake(0, - (tabBarHeight - height), kScreenW, tabBarHeight)];
    //改动原因：用系统的tabbar高度
    YYTabBar *tabBar = [[YYTabBar alloc] initWithFrame:CGRectMake(0,0, kScreenW, height)];
    tabBar.tabCount = count;
    tabBar.block = selectedBlock;
    
//    [tabBar setBackgroundImage:[ImageUtil gradientImageWithColors:[NSArray arrayWithObjects:[UIColor colorWithHexString:@"F3F4F6"],[UIColor colorWithHexString:@"F3F4F6"], nil] withSize:tabBar.frame.size]];
    [tabBar setShadowImage:[UIImage new]];
    
    /** 获取button的宽度 */
    CGFloat tabBarItemWidth = kScreenW / count ;
    /** 设置背景颜色 */
    tabBar.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    
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
        [btn setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        //边框宽度和颜色
        [btn.layer setBorderWidth:0.5];
        btn.layer.borderColor=[UIColor colorWithHexString:@"bfbfbf"].CGColor;
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
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
//    line.backgroundColor = [UIColor colorWithHexString:@"E6E9ED"];
//    [tabBar addSubview:line];
    
    return tabBar;
}

- (void)setTabAtIndex:(NSInteger)index title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    YYTabBarItem *tabBarItem = self.subviews[index];
    
    [tabBarItem setTitle:title forState:UIControlStateNormal];
    [tabBarItem setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    [tabBarItem setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];

    [tabBarItem setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [tabBarItem setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
}

#pragma mark - view methods
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize s = [super sizeThatFits:size];
    if(@available(iOS 11.0, *))
    {
        CGFloat bottomInset = self.safeAreaInsets.bottom;
        if( bottomInset > 0 && s.height < 50) {
            s.height += bottomInset;
        }
    }
    return s;
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
    [self.selectedBtn setBackgroundColor:[UIColor colorWithHexString:@"fbfbfb"]];
    //边框颜色跟着变
    self.selectedBtn.layer.borderColor=[UIColor colorWithHexString:@"bfbfbf"].CGColor;
    /** 把当前选中的button设置为选中 */
    btn.selected = YES;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"1c82d4"]];
    //边框颜色跟着变
    btn.layer.borderColor=[UIColor colorWithHexString:@"1c82d4"].CGColor;
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

- (void) safeAreaInsetsDidChange
{
    [super safeAreaInsetsDidChange];
    if(self.oldSafeAreaInsets.left != self.safeAreaInsets.left ||
       self.oldSafeAreaInsets.right != self.safeAreaInsets.right ||
       self.oldSafeAreaInsets.top != self.safeAreaInsets.top ||
       self.oldSafeAreaInsets.bottom != self.safeAreaInsets.bottom)
    {
        self.oldSafeAreaInsets = self.safeAreaInsets;
        [self invalidateIntrinsicContentSize];
        [self.superview setNeedsLayout];
        [self.superview layoutSubviews];
    }
    
}


@end
