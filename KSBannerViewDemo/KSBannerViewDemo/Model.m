//
//  Model.m
//  KSBannerViewDemo
//
//  Created by Mr.kong on 2017/5/4.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "Model.h"
#import "KSBannerViewProcotal.h"
@implementation Model

- (NSString*)bannerViewImageURLString{
    return self.imageUrl;
}

- (NSString*)placeholderImageName{
    return @"";
}

- (BOOL)isWebImage{
    return YES;
}

@end
