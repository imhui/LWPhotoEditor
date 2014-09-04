LWPhotoEditor
=============

iOS photo editor


###Useage
```
import "LWPhotoEditor.h"

LWPhotoEditor *photoEditor = [[LWPhotoEditor alloc] init];
photoEditor.image = image;
photoEditor.cropOptions = @[@(LWPhotoEditorCropOptionSquare), @(LWPhotoEditorCropOption4x3), @(LWPhotoEditorCropOption3x2), @(LWPhotoEditorCropOption16x9)];
photoEditor.delegate = self;
[self presentViewController:photoEditor animated:YES completion:nil];

```