#import <UIKit/UIKit.h>

@class NGMessage;

NS_ASSUME_NONNULL_BEGIN

@interface NGMessageCell : UITableViewCell

+ (CGFloat)heightForMessage:(NGMessage *)message constrainedWidth:(CGFloat)width;
- (void)configureWithMessage:(NGMessage *)message;

@end

NS_ASSUME_NONNULL_END
