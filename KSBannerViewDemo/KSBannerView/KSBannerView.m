//
//  KSBannerView.m
//  test
//
//  Created by Mr.kong on 2017/4/27.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSBannerView.h"
#import "KSBannerViewProcotal.h"
#import "KSBannerViewItem.h"
#import <SDWebImagePrefetcher.h>
#import "KSPageControl.h"

@interface KSBannerView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView                          * collectionView;
@property (nonatomic, strong) KSPageControl                             * pageControl;
@property (nonatomic, strong) NSTimer                                   * timer;

@property (nonatomic, assign) NSUInteger                                currentPage;

@property (nonatomic, strong) NSMutableArray<id<KSBannerViewDataSource>>* temp;

@end

@implementation KSBannerView

- (instancetype)init
{    
    self = [super init];
    if (self) {
        self.timeInterval = 3.;
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:self.images.count];
    
    CGFloat pageControlW = pageControlSize.width;
    CGFloat pageControlH = pageControlSize.height;
    CGFloat pageControlX = (CGRectGetWidth(self.frame) - pageControlW) / 2;
    CGFloat pageControlY = CGRectGetHeight(self.frame) - pageControlH;
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    
}

- (void)setImages:(NSArray<id<KSBannerViewDataSource>> *)images{
    _images = images;
    
    NSMutableArray* urls = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(id<KSBannerViewDataSource>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [urls addObject:[NSURL URLWithString:[obj bannerViewImageURLString]]];
    }];
    
    //预加载图片
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf resetDataSource];
    });
}

- (void)resetDataSource{
    
    self.pageControl.hidden = self.pageControlHidden;
    if (!self.pageControl.hidden) {
        self.pageControl.numberOfPages = self.images.count;
    }
    
    self.temp = [NSMutableArray arrayWithArray:self.images];
    
    if (self.images.count == 1 && !self.automicScrollForSigle) {
        [self.collectionView reloadData];
    }else{
        
        if (self.infinite) {
            [self.temp insertObject:self.images.lastObject atIndex:0];
            [self.temp addObject:self.images.firstObject];
            [self.collectionView reloadData];
            [self collectionViewScrollToPage:1 animated:NO];
        }else{
            [self.collectionView reloadData];
        }
        
        if (self.automicScroll) {
            [self.timer invalidate];
            self.timer = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.timer fire];
            });
        }
    }
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.temp.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KSBannerViewItem* item = [collectionView dequeueReusableCellWithReuseIdentifier:KSBannerViewItemID forIndexPath:indexPath];
    item.contentsGravity = self.contentsGravity;
    item.banner = self.temp[indexPath.row];
    return item;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.didSelectedHandle) {
        self.didSelectedHandle(self.currentPage, self.images[self.currentPage]);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.automicScroll) {
        self.timer.fireDate = [NSDate distantFuture];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.automicScroll) {
        self.timer.fireDate = [NSDate distantPast];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.didEndScrollHandle) {
        self.didEndScrollHandle(self.currentPage, self.images[self.currentPage]);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.didEndScrollHandle) {
        self.didEndScrollHandle(self.currentPage, self.images[self.currentPage]);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.didScrollHandle) {
        self.didScrollHandle(scrollView);
    }
    
    [self adjustCollectionContentOffset];

    [self resetPageControlCurrentPage];
}

//调整collectionView偏移量
- (void)adjustCollectionContentOffset{
    if (!self.infinite) { return; }
    
    float contentOffsetX = self.collectionView.contentOffset.x;
    
    float scrollPosit = (self.collectionView.frame.size.width) * (self.temp.count - 1);
    
    //向左滚动到起始点
    if (contentOffsetX < 0) {
        [self collectionViewScrollToPage:self.temp.count - 2 animated:NO];
    }
    
    //向右滚动到终点
    if (contentOffsetX >= scrollPosit) {
        [self collectionViewScrollToPage:1 animated:NO];
    }
}

//自动滚动到下一页
- (void)scrollToNextPage{
    if (self.infinite) {
        
        float contentOffsetX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.frame);
        
        [self.collectionView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
        
    }else{
        float contentOffsetX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.frame);
        if (contentOffsetX >= self.collectionView.contentSize.width) {
            contentOffsetX = 0;
        }
        [self.collectionView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    }
    
}

//滚动到指定页面
- (void)collectionViewScrollToPage:(NSUInteger)index animated:(BOOL)animated{

    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:animated];
}

//设置指示器
- (void)resetPageControlCurrentPage{
    
    if (!self.pageControl.hidden) {
        
        if (self.pageControl.currentPage != self.currentPage) {
            self.pageControl.currentPage = self.currentPage;
        }
    }
}

- (void)dealloc{
    [[SDWebImagePrefetcher sharedImagePrefetcher] cancelPrefetching];
}

#pragma mark- Setter
- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage{
    _currentPageIndicatorImage = currentPageIndicatorImage;
    self.pageControl.currentPageIndicatorImage = currentPageIndicatorImage;
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage{
    _pageIndicatorImage = pageIndicatorImage;
    self.pageControl.pageIndicatorImage = pageIndicatorImage;
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage{
    _hidesForSinglePage = hidesForSinglePage;
    self.pageControl.hidesForSinglePage = hidesForSinglePage;
}

#pragma mark- Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        
        [_collectionView registerClass:KSBannerViewItem.class
            forCellWithReuseIdentifier:KSBannerViewItemID];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (KSPageControl*)pageControl{
    if (!_pageControl) {
        _pageControl = [[KSPageControl alloc] init];
    }
    return _pageControl;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.timeInterval
                                         target:self
                                       selector:@selector(scrollToNextPage)
                                       userInfo:nil
                                        repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer
                                     forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (NSUInteger)currentPage{
    
    if (self.images.count == 1) { return 0; }
    
    NSUInteger page = lroundf(self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame));
    
    if (self.infinite) {
        if (page == self.temp.count - 1) {
            page = 0;
        }else if (page == 0){
            page = self.temp.count - 3;
        }else{
            page = page - 1;
        }
    }
    _currentPage = page;
    
    return _currentPage;
}
@end
