//
//  KSBannerViewItem.h
//  test
//
//  Created by Mr.kong on 2017/4/27.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSBannerViewDataSource;
@interface KSBannerViewItem : UICollectionViewCell

@property (nonatomic, strong) id<KSBannerViewDataSource>banner;

@property (nonatomic, copy) NSString *contentsGravity;

@end

UIKIT_EXTERN NSString * const KSBannerViewItemID;
