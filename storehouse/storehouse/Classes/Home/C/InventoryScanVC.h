//
//  InventoryScanVC.h
//  storehouse
//
//  Created by 万宇 on 2018/12/12.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//1.定义协议
@protocol barCodeDelegate<NSObject>
- (void)returnBarCode:(NSString *)barCode;
@end
//2.定义代理
@interface InventoryScanVC : UIViewController
@property (nonatomic, retain) id <barCodeDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
