#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NGChatInputBar;

@protocol NGChatInputBarDelegate <NSObject>

- (void)chatInputBar:(NGChatInputBar *)inputBar didSendText:(NSString *)text;

@end

@interface NGChatInputBar : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<NGChatInputBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
