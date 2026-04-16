#import <UIKit/UIKit.h>

@class NGDialog;
@protocol NGAvatarProviding;
@protocol NGMessagingBackend;

NS_ASSUME_NONNULL_BEGIN

@class NGChatsViewController;

@protocol NGChatsViewControllerDelegate <NSObject>

- (void)chatsViewController:(NGChatsViewController *)controller didSelectDialog:(NGDialog *)dialog;

@end

@interface NGChatsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<NGChatsViewControllerDelegate> delegate;

- (instancetype)initWithBackend:(id<NGMessagingBackend>)backend avatarProvider:(id<NGAvatarProviding>)avatarProvider;

@end

NS_ASSUME_NONNULL_END
