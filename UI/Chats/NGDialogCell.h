#import <UIKit/UIKit.h>

@class NGDialog;
@protocol NGAvatarProviding;

NS_ASSUME_NONNULL_BEGIN

@interface NGDialogCell : UITableViewCell

- (void)configureWithDialog:(NGDialog *)dialog avatarProvider:(id<NGAvatarProviding>)avatarProvider;

@end

NS_ASSUME_NONNULL_END
