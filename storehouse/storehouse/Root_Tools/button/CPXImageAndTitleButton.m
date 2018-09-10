//
//  CPXImageAndTitleButton.m
//  ChuPinXiu
//
//  Created by cpx on 16/1/20.
//  Copyright © 2016年 chupinxiu. All rights reserved.
//

#import "CPXImageAndTitleButton.h"
#import "UIView+Utils.h"

@implementation CPXImageAndTitleButton


- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.currentTitle || !self.imageView.image) {
        return;
    }
    [self.titleLabel sizeToFit];
    switch (self.imagePosition) {
        case CPXImageAndTitleButtonImagePositionLeft:{
            self.imageView.left = (self.width - self.imageAndTitleOffset - self.imageView.width - self.titleLabel.width)/2;
            self.titleLabel.left = self.imageView.right + self.imageAndTitleOffset;
            self.imageView.centerY =
            self.titleLabel.centerY = self.height/2;
        }
            break;
        case CPXImageAndTitleButtonImagePositionRight:{
            self.titleLabel.left = (self.width - self.imageAndTitleOffset - self.imageView.width - self.titleLabel.width)/2;
            if (self.titleLabel.left <= 0) {
                self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                self.titleLabel.left = 0;
                self.imageView.right = self.width;
                self.titleLabel.width = self.imageView.left - self.imageAndTitleOffset - self.titleLabel.left;
            }
            self.imageView.left = self.titleLabel.right + self.imageAndTitleOffset;
            self.imageView.centerY =
            self.titleLabel.centerY = self.height/2;
        }
            break;
        case CPXImageAndTitleButtonImagePositionUp:{
            self.imageView.top = (self.height - self.imageAndTitleOffset - self.imageView.height - self.titleLabel.height)/2;
            self.titleLabel.top = self.imageView.bottom + self.imageAndTitleOffset;
            self.imageView.centerX =
            self.titleLabel.centerX = self.width/2;
        }
            break;
        case CPXImageAndTitleButtonImagePositionDown:{
            self.titleLabel.top = (self.height - self.imageAndTitleOffset - self.imageView.height - self.titleLabel.height)/2;
            self.imageView.top = self.titleLabel.bottom + self.imageAndTitleOffset;
            self.imageView.centerX =
            self.titleLabel.centerX = self.width/2;
        }
            break;
            
        default:
            break;
    }
}

@end
