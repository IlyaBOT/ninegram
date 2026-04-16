#import <UIKit/UIKit.h>

@class NGDialog;

NS_ASSUME_NONNULL_BEGIN

typedef void (^NGAvatarCompletion)(UIImage *image);

@protocol NGAvatarProviding <NSObject>

- (void)avatarForDialog:(NGDialog *)dialog diameter:(CGFloat)diameter completion:(NGAvatarCompletion)completion;

@end

NS_ASSUME_NONNULL_END
