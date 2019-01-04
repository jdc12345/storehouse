//
//  ReplaceScanVC.h
//  storehouse
//
//  Created by 万宇 on 2019/1/4.
//  Copyright © 2019 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//1.定义协议
@protocol barCodeDelegate<NSObject>
- (void)returnBarCode:(NSString *)barCode;
@end

@interface ReplaceScanVC : UIViewController
//2.定义代理
@property (nonatomic, retain) id <barCodeDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
