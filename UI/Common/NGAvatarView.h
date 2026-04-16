#import <UIKit/UIKit.h>

@class NGDialog;
@protocol NGAvatarProviding;

NS_ASSUME_NONNULL_BEGIN

@interface NGAvatarView : UIImageView

- (void)configureWithDialog:(NGDialog *)dialog avatarProvider:(id<NGAvatarProviding>)avatarProvider diameter:(CGFloat)diameter;

@end

NS_ASSUME_NONNULL_END
