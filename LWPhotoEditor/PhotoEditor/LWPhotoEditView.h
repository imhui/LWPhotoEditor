//
//  LWPhotoEditView.h
//  LWPhotoEditor
//
//  Created by LiYonghui on 14-9-3.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWPhotoEditorConstants.h"

@interface LWPhotoEditView : UIView

@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) BOOL zoomEnable;
@property (nonatomic, assign) LWPhotoEditorCropOption cropOption;
- (void)cropImageWithCallback:(void(^)(UIImage *image))callback;

@end
