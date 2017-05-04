//
//  ViewController.m
//  KSBannerViewDemo
//
//  Created by Mr.kong on 2017/5/3.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "ViewController.h"
#import "KSBannerView.h"
#import "Model.h"

@interface ViewController ()
@property (nonatomic, strong) KSBannerView* bannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bannerView = [[KSBannerView alloc] init];
    [self.view addSubview:self.bannerView];
    
    Model* obj1 = [[Model alloc] init];
    obj1.imageUrl = @"http://img.ivsky.com/img/bizhi/pre/201703/06/lykan_hypersport.jpg";
    Model* obj2 = [[Model alloc] init];
    obj2.imageUrl = @"http://img03.tooopen.com/images/20160703/tooopen_sy_168772353872.jpg";
    Model* obj3 = [[Model alloc] init];
    obj3.imageUrl = @"http://img05.tooopen.com/images/20151003/tooopen_sy_144338714914.jpg";
    Model* obj4 = [[Model alloc] init];
    obj4.imageUrl = @"http://img05.tooopen.com/images/20150912/tooopen_sy_142398756188.jpg";
    Model* obj5 = [[Model alloc] init];
    obj5.imageUrl = @"http://img05.tooopen.com/images/20150418/tooopen_sy_119212288853.jpg";
    
    NSMutableArray* banners = [NSMutableArray array];
    [banners addObject:obj1];
    [banners addObject:obj2];
    [banners addObject:obj3];
    [banners addObject:obj4];
    [banners addObject:obj5];
    
    self.bannerView.images = banners;
    
    self.bannerView.timeInterval = 3;
    self.bannerView.infinite = YES;
    self.bannerView.automicScroll = YES;
    self.bannerView.automicScrollForSigle = NO;
    self.bannerView.contentsGravity = kCAGravityResizeAspectFill;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.bannerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) / 2);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
