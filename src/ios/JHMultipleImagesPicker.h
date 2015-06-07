#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface JHMultipleImagesPicker : CDVPlugin <UIAlertViewDelegate> {}
- (void)hello:(CDVInvokedUrlCommand*)command;
@end

@interface MyAlertView : UIAlertView {}
@property (nonatomic, copy) NSString* callbackId;
@end