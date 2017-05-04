//
//  KSBannerViewItem.m
//  test
//
//  Created by Mr.kong on 2017/4/27.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSBannerViewItem.h"
#import "KSBannerViewProcotal.h"
#import <SDWebImageManager.h>

@implementation KSBannerViewItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.contentView.layer.contents = nil;
}

- (void)setContentsGravity:(NSString *)contentsGravity{
    _contentsGravity = [contentsGravity copy];
    self.contentView.layer.contentsGravity = contentsGravity;
}

- (void)setBanner:(id<KSBannerViewDataSource>)banner{
    _banner = banner;
    
    __weak typeof(self) weakSelf    = self;
    BOOL isWebImage                 = [banner respondsToSelector:@selector(isWebImage)] ? [banner isWebImage] : YES;
    NSString* placeholder           = [banner respondsToSelector:@selector(placeholderImageName)] ? [banner placeholderImageName] : @"";
    NSString* urlName               = [banner respondsToSelector:@selector(bannerViewImageURLString)] ? [banner bannerViewImageURLString] : @"";
    
    if (placeholder.length == 0) return;
    
    self.contentView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:placeholder].CGImage);
    
    if (urlName.length == 0) return;
    
    if (!isWebImage) {
        self.contentView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:urlName].CGImage);
    }else{
        
        NSURL* url = [NSURL URLWithString:urlName];
        [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                    options:SDWebImageLowPriority
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * targetURL) {
                                                       
                                                   } completed:^(UIImage * image, NSData * data, NSError * error, SDImageCacheType cacheType, BOOL finished, NSURL * imageURL) {
                                                       if (error) { return ;}
                                                       weakSelf.contentView.layer.contents = (__bridge id _Nullable)(image.CGImage);
                                                   }];
    }
}

@end

NSString * const KSBannerViewItemID = @"KSBannerViewItemID";
