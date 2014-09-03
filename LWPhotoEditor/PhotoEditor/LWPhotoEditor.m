//
//  LWPhotoEditor.m
//  LWPhotoEditor
//
//  Created by LiYonghui on 14-9-3.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "LWPhotoEditor.h"
#import "LWPhotoEditView.h"

@interface LWPhotoEditor () {
    
    LWPhotoEditView *_photoEditView;
    
}

@end

@implementation LWPhotoEditor

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initEditView];
    _photoEditView.image = self.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)nameWithCropOption:(LWPhotoEditorCropOption)option {
    if (option == LWPhotoEditorCropOptionSquare) {
        return NSLocalizedString(@"1:1", nil);
    }
    if (option == LWPhotoEditorCropOption16x9) {
        return NSLocalizedString(@"16:9", nil);
    }
    if (option == LWPhotoEditorCropOption3x2) {
        return NSLocalizedString(@"3:2", nil);
    }
    if (option == LWPhotoEditorCropOption4x3) {
        return NSLocalizedString(@"4:3", nil);
    }
    return nil;
}

- (void)initEditView {
    
    CGRect viewBounds = self.view.bounds;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(viewBounds) - 44, CGRectGetWidth(viewBounds), 44)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:toolbar];
    
    NSMutableArray *toolbarItems = [@[] mutableCopy];
    [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelItemAction:)]];
    
    if (self.cropOptions.count > 1) {
        for (NSNumber *option in self.cropOptions) {
            [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
            LWPhotoEditorCropOption cropOption = [option integerValue];
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:[self nameWithCropOption:cropOption]
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self action:@selector(optionItemAction:)];
            buttonItem.tag = cropOption;
            [toolbarItems addObject:buttonItem];
        }
    }
    
    [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneItemAction:)]];
    [toolbar setItems:toolbarItems animated:NO];
    
    
    _photoEditView = [[LWPhotoEditView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBounds), CGRectGetHeight(viewBounds) - CGRectGetHeight(toolbar.bounds))];
    _photoEditView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _photoEditView.zoomEnable = YES;
    [self.view addSubview:_photoEditView];
    if (self.cropOptions.count) {
        _photoEditView.cropOption = [self.cropOptions[0] intValue];
    }
}

- (void)cancelItemAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(photoEditorDidCancel:)]) {
        [_delegate photoEditorDidCancel:self];
    }
}

- (void)optionItemAction:(UIBarButtonItem *)sender {
    _photoEditView.cropOption = sender.tag;
}

- (void)doneItemAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(photoEditor:didFinishEditingWithImage:)]) {
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.center = _photoEditView.center;
        indicatorView.hidesWhenStopped = YES;
        [self.view addSubview:indicatorView];
        [indicatorView startAnimating];
        
        [_photoEditView cropImageWithCallback:^(UIImage *cropImage) {
            [_delegate photoEditor:self didFinishEditingWithImage:cropImage];
            [indicatorView stopAnimating];
            [indicatorView removeFromSuperview];
        }];
        
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}


@end
