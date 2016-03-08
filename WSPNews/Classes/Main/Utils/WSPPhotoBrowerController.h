//
//  WSPPhotoBrowerController.h
//  WSPNews
//
//  Created by auto on 16/3/4.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPPhoto.h"
@class WSPPhotoBrowerController;

@protocol WSPPhotoBrowerDelegate <NSObject>

//- (NSUInteger)numberOfPhotosInPhotoBrowser:(WSPPhotoBrowerController *)photoBrowser;
//- (id <WSPPhotoProtocol>)photoBrowser:(WSPPhotoBrowerController *)photoBrowser photoAtIndex:(NSUInteger)index;
@optional

- (id <WSPPhotoProtocol>)photoBrowser:(WSPPhotoBrowerController *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;

- (NSString *)photoBrowser:(WSPPhotoBrowerController *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(WSPPhotoBrowerController *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(WSPPhotoBrowerController *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(WSPPhotoBrowerController *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(WSPPhotoBrowerController *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;
- (void)photoBrowserDidFinishModalPresentation:(WSPPhotoBrowerController *)photoBrowser;

@end

@interface WSPPhotoBrowerController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger photosCount;
// Init
- (id)initWithPhotos:(NSArray *)photosArray;
- (id)initWithDelegate:(id <WSPPhotoBrowerDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setCurrentPhotoIndex:(NSUInteger)index;

// Navigation
- (void)showNextPhotoAnimated:(BOOL)animated;
- (void)showPreviousPhotoAnimated:(BOOL)animated;
@end
