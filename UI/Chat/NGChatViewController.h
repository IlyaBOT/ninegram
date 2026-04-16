#import <UIKit/UIKit.h>

@class NGDialog;
@protocol NGMessagingBackend;

NS_ASSUME_NONNULL_BEGIN

@interface NGChatViewController : UIViewController

- (instancetype)initWithDialog:(NGDialog *)dialog backend:(id<NGMessagingBackend>)backend;

@end

NS_ASSUME_NONNULL_END
