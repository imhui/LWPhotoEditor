//
//  ViewController.m
//  LWPhotoEditor
//
//  Created by LiYonghui on 14-9-3.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "LWPhotoEditor.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, LWPhotoEditorDelegate> {
    UIImageView *_imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds))];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_imageView.frame) + 50);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [button setTitle:NSLocalizedString(@"选择图片", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(choseImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)choseImage:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    LWPhotoEditor *photoEditor = [[LWPhotoEditor alloc] init];
    photoEditor.image = image;
    photoEditor.cropOptions = @[@(LWPhotoEditorCropOptionSquare), @(LWPhotoEditorCropOption4x3), @(LWPhotoEditorCropOption3x2), @(LWPhotoEditorCropOption16x9)];
    photoEditor.delegate = self;
    [self presentViewController:photoEditor animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoEditor:(LWPhotoEditor *)photoEditor didFinishEditingWithImage:(UIImage *)image {
    _imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoEditorDidCancel:(LWPhotoEditor *)photoEditor {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
