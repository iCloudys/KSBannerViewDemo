//
//  KSPageControl.m
//  KSBannerViewDemo
//
//  Created by Mr.kong on 2017/5/4.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSPageControl.h"

@implementation KSPageControl

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.pageIndicatorImage) {
        __weak typeof(self) weakSelf = self;
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == weakSelf.currentPage) {
                obj.layer.contents = (__bridge id _Nullable)(weakSelf.currentPageIndicatorImage.CGImage);
            }else{
                obj.layer.contents = (__bridge id _Nullable)(weakSelf.pageIndicatorImage.CGImage);
            }
        }];
    }
}


- (void)setCurrentPage:(NSInteger)currentPage{

    if (self.subviews.count > 0 && currentPage != self.currentPage && self.pageIndicatorImage) {
        self.subviews[self.currentPage].layer.contents = (__bridge id _Nullable)(self.pageIndicatorImage.CGImage);
    }
    
    [super setCurrentPage:currentPage];
    
    if (self.subviews.count > 0 && self.currentPageIndicatorImage) {
        self.subviews[self.currentPage].layer.contents = (__bridge id _Nullable)(self.currentPageIndicatorImage.CGImage);
    }
}

@end
