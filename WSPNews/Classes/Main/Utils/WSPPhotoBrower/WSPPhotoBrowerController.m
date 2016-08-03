//
//  WSPPhotoBrowerController.m
//  WSPNews
//
//  Created by auto on 16/3/4.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPPhotoBrowerController.h"

#define PADDING 10

@interface WSPPhotoBrowerController () {
    UIScrollView *_pagingScrollView;
    UIToolbar    *_toolbar;
    
    // Data
    NSUInteger _photoCount;
    NSMutableArray *_photos;
    NSMutableArray *_thumbPhotos;
    
}

@end

@implementation WSPPhotoBrowerController

- (id)init {
    if ((self = [super init])) {
        
    }
    return self;
}
- (id)initWithPhotos:(NSArray *)photosArray {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithDelegate:(id<WSPPhotoBrowerDelegate>)delegate {
    if (self = [super init]) {
        
    }
    return self;
}
- (void)setCurrentPhotoIndex:(NSUInteger)index {
    NSLog(@"%ld",index);
}
- (void)showNextPhotoAnimated:(BOOL)animated {
    
}
- (void)showPreviousPhotoAnimated:(BOOL)animated {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.delegate = self;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    _pagingScrollView.backgroundColor = [UIColor blackColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    [self.view addSubview:_pagingScrollView];
    
    
    
    // Toolbar
    _toolbar = [[UIToolbar alloc] initWithFrame:[self frameForToolbarAtOrientation:self.interfaceOrientation]];
    _toolbar.tintColor = [UIColor whiteColor];
    _toolbar.barTintColor = nil;
    [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Frame Calculations

- (CGRect)frameForPagingScrollView {
    CGRect frame = self.view.bounds;// [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return CGRectIntegral(frame);
}
- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * /*[self numberOfPhotos]*/self.photosCount, bounds.size.height);
}
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation {
    CGFloat height = 44;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        UIInterfaceOrientationIsLandscape(orientation)) height = 32;
    return CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height));
}
- (void)reloadData {
    
    // Reset
//    _photoCount = NSNotFound;
//    
//    // Get data
//    NSUInteger numberOfPhotos = [self numberOfPhotos];
////    [self releaseAllUnderlyingPhotos:YES];
//    [_photos removeAllObjects];
//    [_thumbPhotos removeAllObjects];
//    for (int i = 0; i < numberOfPhotos; i++) {
//        [_photos addObject:[NSNull null]];
//        [_thumbPhotos addObject:[NSNull null]];
//    }
//    
//    // Update current page index
//    if (numberOfPhotos > 0) {
//        _currentPageIndex = MAX(0, MIN(_currentPageIndex, numberOfPhotos - 1));
//    } else {
//        _currentPageIndex = 0;
//    }
//    
//    // Update layout
//    if ([self isViewLoaded]) {
//        while (_pagingScrollView.subviews.count) {
//            [[_pagingScrollView.subviews lastObject] removeFromSuperview];
//        }
//        [self performLayout];
//        [self.view setNeedsLayout];
//    }
    
}
//- (NSUInteger)numberOfPhotos {
//    if (_photoCount == NSNotFound) {
//        if ([_delegate respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
//            _photoCount = [_delegate numberOfPhotosInPhotoBrowser:self];
//        } else if (_fixedPhotosArray) {
//            _photoCount = _fixedPhotosArray.count;
//        }
//    }
//    if (_photoCount == NSNotFound) _photoCount = 0;
//    return _photoCount;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
