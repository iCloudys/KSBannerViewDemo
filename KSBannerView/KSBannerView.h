//
//  KSBannerView.h
//  test
//
//  Created by Mr.kong on 2017/4/27.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSBannerViewDataSource;
@protocol KSBannerViewDelegate;

typedef void(^KSBannerViewDidScrollHandle)(UIScrollView* scrollView);
typedef void(^KSBannerViewDidSelectedHandle)(NSUInteger idx,id<KSBannerViewDataSource> obj);
typedef void(^KSBannerViewDidEndScrollHandle)(NSUInteger idx,id<KSBannerViewDataSource> obj);

@interface KSBannerView : UIView

@property (nonatomic, strong) NSArray<id<KSBannerViewDataSource>>* images;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 点击某个Banner回调
 */
@property (nonatomic, copy) KSBannerViewDidSelectedHandle  didSelectedHandle;

/**
 滚动到某个item回调,可能会回调两次
 */
@property (nonatomic, copy) KSBannerViewDidEndScrollHandle  didEndScrollHandle;

/**
 滚动时回调
 */
@property (nonatomic, copy) KSBannerViewDidScrollHandle  didScrollHandle;


//@property (nonatomic, weak) id<KSBannerViewDelegate> delegate;

/**
 轮播时间间隔 (单位 秒). 默认3s
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 是否需要无限滚动，默认NO
 */
@property (nonatomic, assign) BOOL infinite;

/**
 是否要自动滚动，默认为NO,如果需要自动滚动，需要指定为YES
 */
@property (nonatomic, assign) BOOL automicScroll;

/**
 单张图片是否需要轮播,默认NO。如果需要轮播，首先设置automicScroll为YES
 */
@property (nonatomic, assign) BOOL automicScrollForSigle;

/**
 页面指示器隐藏,默认NO
 */
@property (nonatomic, assign) BOOL pageControlHidden;

/**
 图片填充模式，默认kCAGravityResize .参考[CALayer contentsGravity]
 */
@property (nonatomic, copy) NSString *contentsGravity;

@end
