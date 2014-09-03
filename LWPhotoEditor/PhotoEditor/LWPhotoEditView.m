//
//  LWPhotoEditView.m
//  LWPhotoEditor
//
//  Created by LiYonghui on 14-9-3.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "LWPhotoEditView.h"

@interface LWPhotoCropView : UIView {
    
}

@property (nonatomic, assign) LWPhotoEditorCropOption cropOption;

@end

@implementation LWPhotoCropView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (self.superview) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.3].CGColor);

        CGRect visiableRect = [self visiableRect];
        
        CGRect fillRect = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetMinY(visiableRect));
        CGContextFillRect(context, fillRect);
        
        fillRect = CGRectMake(0, CGRectGetMaxY(visiableRect), CGRectGetWidth(rect), CGRectGetHeight(rect) - CGRectGetMaxY(visiableRect));
        CGContextFillRect(context, fillRect);
        
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGContextStrokeRect(context, visiableRect);
        
    }
    
}


- (CGRect)visiableRect {
    
    CGRect rect = self.bounds;
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    width = CGRectGetWidth(rect) < CGRectGetHeight(rect) ? CGRectGetWidth(rect) : CGRectGetHeight(rect);
    if (_cropOption == LWPhotoEditorCropOption16x9) {
        height = width / 16 * 9;
    }
    else if (_cropOption == LWPhotoEditorCropOption4x3) {
        height = width / 6 * 3;
    }
    else if (_cropOption == LWPhotoEditorCropOption3x2) {
        height = width / 3 * 2;
    }
    else {
        height = width;
    }
    
    CGRect visiableRect = CGRectMake((CGRectGetWidth(rect) - width) / 2, (CGRectGetHeight(rect) - height) / 2, width, height);
    return visiableRect;
}

- (void)setCropOption:(LWPhotoEditorCropOption)cropOption {
    _cropOption = cropOption;
    [self setNeedsDisplay];
}


@end


@interface LWPhotoEditView () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    LWPhotoCropView *_cropView;
    UIEdgeInsets _scrollViewContentInset;
}

@end

@implementation LWPhotoEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_imageView];
        
        _cropView = [[LWPhotoCropView alloc] initWithFrame:self.bounds];
        _cropView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_cropView];
        
        self.cropOption = LWPhotoEditorCropOptionSquare;
        
    }
    return self;
}


- (void)layoutImage {

    if (_imageView.image == nil) {
        return;
    }
    
    _scrollView.zoomScale = _scrollView.minimumZoomScale;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat scale = imageSize.width / CGRectGetWidth(_scrollView.bounds);
    imageSize = CGSizeMake(CGRectGetWidth(_scrollView.bounds), ceilf(imageSize.height / scale));
    
    CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    if (imageSize.height <= CGRectGetHeight(_scrollView.bounds)) {
        imageFrame.origin.y = (CGRectGetHeight(_scrollView.bounds) - imageSize.height) / 2.0;
    }
    _imageView.frame = imageFrame;
    
    CGSize contentSize = imageSize;
    if (imageSize.height < CGRectGetHeight(_scrollView.bounds)) {
        contentSize.height = CGRectGetHeight(_scrollView.bounds);
    }
    _scrollView.contentSize = contentSize;
    
    NSLog(@"=====================");
    NSLog(@"content size: %@", NSStringFromCGSize(_scrollView.contentSize));
    
    
    CGRect visiableRect = [_cropView visiableRect];
    
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    if (imageSize.height < CGRectGetHeight(_scrollView.bounds)) {
        if (imageSize.height > CGRectGetHeight(visiableRect)) {
            contentInset.top = (imageSize.height - CGRectGetHeight(visiableRect)) / 2;
            contentInset.bottom = contentInset.top;
        }
//        else {
//            contentInset.top = (CGRectGetHeight(visiableRect) - imageSize.height) / 2;
//            contentInset.bottom = contentInset.top;
//        }
    }
    else {
        contentInset.top = (CGRectGetHeight(_scrollView.bounds) - CGRectGetHeight(visiableRect)) / 2.0;
        contentInset.bottom = contentInset.top;
    }
    
    _scrollView.contentInset = contentInset;
    _scrollViewContentInset = _scrollView.contentInset;
    
    NSLog(@"content size: %@", NSStringFromCGSize(_scrollView.contentSize));
    NSLog(@"content inset: %@", NSStringFromUIEdgeInsets(_scrollViewContentInset));
}

#pragma mark - property
- (void)setImage:(UIImage *)image {
    
    _imageView.image = image;
    [self layoutImage];
    
}

- (void)setCropOption:(LWPhotoEditorCropOption)cropOption {
    _cropOption = cropOption;
    _cropView.cropOption = cropOption;
    [self layoutImage];
}


- (void)setZoomEnable:(BOOL)enable {
    
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = enable ? 3 : _scrollView.minimumZoomScale;
    _scrollView.zoomScale = _scrollView.minimumZoomScale;
}


#pragma mark 
- (void)cropImageWithCallback:(void(^)(UIImage *image))callback {
    
    if (!callback) {
        return;
    }
    
    CGRect visiableRect = [_cropView visiableRect];
    CGFloat originY = _scrollView.contentInset.top + _scrollView.contentOffset.y;
    
    
    CGFloat width = CGRectGetWidth(visiableRect);
    CGFloat height = CGRectGetHeight(visiableRect);
    if (height > CGRectGetHeight(_imageView.bounds)) {
        height = CGRectGetHeight(_imageView.bounds);
    }
    
    CGFloat scale = _imageView.image.size.width / CGRectGetWidth(_scrollView.bounds);
    CGRect cropRect = CGRectMake(0, originY * scale, width * scale , height * scale);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *cropImage = [self cropImage:_imageView.image inRect:cropRect];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(cropImage);
        });
    });
}

- (UIImage *)cropImage:(UIImage *) image inRect:(CGRect)rect {
    
    if (image == nil) {
        return nil;
    }
    
    if (CGPointEqualToPoint(CGPointZero, rect.origin) && CGSizeEqualToSize(rect.size, image.size)) {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    [image drawAtPoint:(CGPoint){-rect.origin.x, -rect.origin.y}];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    NSLog(@">>>>>> content size: %@", NSStringFromCGSize(_scrollView.contentSize));
    CGFloat offsetX = (CGRectGetWidth(scrollView.bounds) > scrollView.contentSize.width) ? (CGRectGetWidth(scrollView.bounds) - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (CGRectGetHeight(scrollView.bounds) > scrollView.contentSize.height) ? (CGRectGetHeight(scrollView.bounds) - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    if (scale == scrollView.minimumZoomScale) {
        [self layoutImage];
    }
//    else {
//        
//        if (CGRectGetHeight(_scrollView.bounds) > _scrollView.contentSize.height) {
//            CGFloat insetOffset = CGRectGetHeight(_scrollView.bounds) - _scrollView.contentSize.height;
//            UIEdgeInsets insets = _scrollView.contentInset;
//            insets.top = insetOffset / 2 * scale;
//            insets.bottom = insetOffset / 2 + CGRectGetMinY([_cropView visiableRect]);
//            _scrollView.contentInset = insets;
//            
////            CGPoint contentOffset = _scrollView.contentOffset;
////            contentOffset.y = 0;
////            _scrollView.contentOffset = contentOffset;
//            
//            NSLog(@"content inset: %@", NSStringFromUIEdgeInsets(_scrollView.contentInset));
//            NSLog(@"content offset: %@", NSStringFromCGPoint(_scrollView.contentOffset));
//        }
//        else {
//            _scrollView.contentInset = _scrollViewContentInset;
//        }
//
//    }
}

@end
