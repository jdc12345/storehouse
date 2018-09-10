//
//  NSString+URL.h
//  storehouse
//
//  Created by 万宇 on 2018/8/6.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;
@end
