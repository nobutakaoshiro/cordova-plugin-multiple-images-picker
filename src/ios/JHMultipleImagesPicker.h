#import <Cordova/CDVPlugin.h>
#import "UzysAssetsPickerController.h"

@interface JHMultipleImagesPicker : CDVPlugin <UzysAssetsPickerControllerDelegate> {}

@property (nonatomic, copy) NSString* callbackId;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionPhoto;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionVideo;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionMedia;

- (void)getPictures:(CDVInvokedUrlCommand*)command;
@end
