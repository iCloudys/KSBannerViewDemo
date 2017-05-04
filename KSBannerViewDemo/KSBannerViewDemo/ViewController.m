//
//  ViewController.m
//  KSBannerViewDemo
//
//  Created by Mr.kong on 2017/5/3.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "ViewController.h"
#import "BannerViewController.h"
#import "ImageBrowerViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)pushBannerViewController{
    BannerViewController* banner = [[BannerViewController alloc] init];
    [self showViewController:banner sender:nil];
}

- (IBAction)pushImageBrowerViewController{
    ImageBrowerViewController* banner = [[ImageBrowerViewController alloc] init];
    [self showViewController:banner sender:nil];
}


@end
