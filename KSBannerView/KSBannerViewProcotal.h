//
//  KSBannerViewProcotal.h
//  test
//
//  Created by Mr.kong on 2017/4/27.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#ifndef KSBannerViewProcotal_h
#define KSBannerViewProcotal_h

@protocol KSBannerViewDataSource <NSObject>

@required
/**
 图片URLString或者本地图片名
 */
- (NSString*)bannerViewImageURLString;

@optional
/**
 缺省图名
 */
- (NSString*)placeholderImageName;

/**
 是否是网络图片,默认是YES
 */
- (BOOL)isWebImage;

@end


@protocol KSBannerViewDelegate <NSObject>

//

@end

#endif /* KSBannerViewProcotal_h */
