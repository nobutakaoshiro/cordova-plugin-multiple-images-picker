#import <AVFoundation/AVFoundation.h>
#import "JHMultipleImagesPicker.h"

#define CDV_PHOTO_PREFIX @"cdv_photo_"

@implementation JHMultipleImagesPicker
- (void)pluginInitialize
{
}

- (void)getPictures:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSDictionary *options = [command.arguments objectAtIndex: 0];

    self.maximumNumberOfSelectionPhoto = [[options objectForKey:@"maximumNumberOfSelectionPhoto"] integerValue];
    self.maximumNumberOfSelectionVideo = [[options objectForKey:@"maximumNumberOfSelectionVideo"] integerValue];
    self.maximumNumberOfSelectionMedia = [[options objectForKey:@"maximumNumberOfSelectionMedia"] integerValue];

    // Picker config
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];

    // initialize Picker
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    if (self.maximumNumberOfSelectionMedia > 0) {
        picker.maximumNumberOfSelectionMedia = self.maximumNumberOfSelectionMedia;
    } else {
        picker.maximumNumberOfSelectionPhoto = self.maximumNumberOfSelectionPhoto;
        picker.maximumNumberOfSelectionVideo = self.maximumNumberOfSelectionVideo;
    }

    // show Picker
    [self.viewController presentViewController:picker animated:YES completion:^{
        // noop
    }];
}

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    CDVPluginResult* result        = nil;
    NSMutableArray *resultStrings  = [[NSMutableArray alloc] init];
    NSData* data                   = nil;
    NSString* docsPath             = [NSTemporaryDirectory()stringByStandardizingPath];
    NSError* err                   = nil;
    NSFileManager* fileMgr         = [[NSFileManager alloc] init];
    ALAsset* asset                 = nil;
    UIImageOrientation orientation = UIImageOrientationUp;
    CGSize targetSize              = CGSizeMake(2048, 2048);
    NSString* filePath;

    for (ALAsset *asset in assets) {
//        asset = [dict objectForKey:@"ALAsset"];
        // From ELCImagePickerController.m

        int i = 1;
        do {
            filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"jpg"];
        } while ([fileMgr fileExistsAtPath:filePath]);

        @autoreleasepool {
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            CGImageRef imgRef = NULL;

            //defaultRepresentation returns image as it appears in photo picker, rotated and sized,
            //so use UIImageOrientationUp when creating our image below.
//            if (picker.returnsOriginalImage) {
                imgRef = [assetRep fullResolutionImage];
//                orientation = [assetRep orientation];
//            } else {
//                imgRef = [assetRep fullScreenImage];
//            }

//            UIImage* image = [UIImage imageWithCGImage:imgRef scale:1.0f orientation:orientation];
            UIImage *image = [UIImage imageWithCGImage:assetRep.fullResolutionImage
                                               scale:assetRep.scale
                                         orientation:(UIImageOrientation)assetRep.orientation];

            //            if (self.width == 0 && self.height == 0) {
                data = UIImageJPEGRepresentation(image, 100.0f);
//            } else {
//                UIImage* scaledImage = [self imageByScalingNotCroppingForSize:image toSize:targetSize];
//                data = UIImageJPEGRepresentation(scaledImage, self.quality/100.0f);
//            }

            if (![data writeToFile:filePath options:NSAtomicWrite error:&err]) {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
                break;
            } else {
                [resultStrings addObject:[[NSURL fileURLWithPath:filePath] absoluteString]];
            }
        }

    }

    if (nil == result) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultStrings];
    }

    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];

//    CDVPluginResult* result = nil;
//
//    __weak __typeof(self) weakSelf = self;
//    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
//    {
//
//        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            ALAsset *representation = obj;
//
//            NSLog(@"%@", [[representation defaultRepresentation] url]);
//
//            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
//                                               scale:representation.defaultRepresentation.scale
//                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
//            // weakSelf.imageView.image = img;
//            *stop = YES;
//        }];
//
//
//    }
//    else //Video
//    {
//        ALAsset *alAsset = assets[0];
//
//        UIImage *img = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
//                                           scale:alAsset.defaultRepresentation.scale
//                                     orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
//        // weakSelf.imageView.image = img;
//
//
//
//        ALAssetRepresentation *representation = alAsset.defaultRepresentation;
//        NSURL *movieURL = representation.url;
//        NSURL *uploadURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] stringByAppendingString:@".mp4"]];
//        AVAsset *asset      = [AVURLAsset URLAssetWithURL:movieURL options:nil];
//        AVAssetExportSession *session =
//        [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
//
//        session.outputFileType  = AVFileTypeQuickTimeMovie;
//        session.outputURL       = uploadURL;
//
//        [session exportAsynchronouslyWithCompletionHandler:^{
//
//            if (session.status == AVAssetExportSessionStatusCompleted)
//            {
//                NSLog(@"output Video URL %@",uploadURL);
//            }
//
//        }];
//
//  }
//
//    [self.viewController dismissViewControllerAnimated:YES completion:nil];
//    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];


}

@end