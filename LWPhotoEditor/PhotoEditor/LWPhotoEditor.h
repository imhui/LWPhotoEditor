//
//  LWPhotoEditor.h
//  LWPhotoEditor
//
//  Created by LiYonghui on 14-9-3.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWPhotoEditorConstants.h"

@class LWPhotoEditor;
@protocol LWPhotoEditorDelegate <NSObject>

@optional
- (void)photoEditor:(LWPhotoEditor *)photoEditor didFinishEditingWithImage:(UIImage *)image;
- (void)photoEditorDidCancel:(LWPhotoEditor *)photoEditor;

@end

@interface LWPhotoEditor : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *cropOptions;
@property (nonatomic, assign) id<LWPhotoEditorDelegate> delegate;

@end
