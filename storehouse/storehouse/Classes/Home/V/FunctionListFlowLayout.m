//
//  FunctionListFlowLayout.m
//  storehouse
//
//  Created by 万宇 on 2018/6/5.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "FunctionListFlowLayout.h"

@implementation FunctionListFlowLayout
// 准备布局
// 这个方法在调用的时候collectionView已经有的大小
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 计算cell的宽高
    CGFloat w = self.collectionView.bounds.size.width / 4;
    CGFloat h = self.collectionView.bounds.size.height / 2;
    
    // cell的大小
    self.itemSize = CGSizeMake(w, h);
    
    // cell间的间距
    self.minimumInteritemSpacing = 0;
    // 行间距
    self.minimumLineSpacing = 0;
    //
    //    // 组的内间距
    //    self.sectionInset = UIEdgeInsetsMake(0, 0, 16, 0);
}

@end
