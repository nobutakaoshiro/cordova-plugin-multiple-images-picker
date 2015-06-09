#import <Cordova/CDVPlugin.h>
#import "UzysAssetsPickerController.h"

@interface JHMultipleImagesPicker : CDVPlugin <UIAlertViewDelegate> {}
- (void)getPictures:(CDVInvokedUrlCommand*)command;
- (void)hello:(CDVInvokedUrlCommand*)command;
@end

@interface MyAlertView : UIAlertView {}
@property (nonatomic, copy) NSString* callbackId;
@end