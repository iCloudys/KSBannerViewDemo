//
//  Model.h
//  KSBannerViewDemo
//
//  Created by Mr.kong on 2017/5/4.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KSBannerViewDataSource;

@interface Model : NSObject<KSBannerViewDataSource>

@property (nonatomic, copy) NSString*  imageUrl;

@end
