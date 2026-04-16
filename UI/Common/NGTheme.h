#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NGTheme : NSObject

+ (void)applyGlobalAppearance;

+ (UIColor *)backgroundColor;
+ (UIColor *)surfaceColor;
+ (UIColor *)separatorColor;
+ (UIColor *)accentColor;
+ (UIColor *)primaryTextColor;
+ (UIColor *)secondaryTextColor;
+ (UIColor *)unreadBadgeColor;
+ (UIColor *)incomingBubbleColor;
+ (UIColor *)outgoingBubbleColor;
+ (UIColor *)bubbleBorderColor;
+ (UIColor *)inputFieldBackgroundColor;
+ (UIColor *)placeholderTextColor;
+ (UIColor *)headerPillColor;

+ (UIFont *)navigationTitleFont;
+ (UIFont *)dialogTitleFont;
+ (UIFont *)dialogPreviewFont;
+ (UIFont *)dialogTimestampFont;
+ (UIFont *)badgeFont;
+ (UIFont *)messageFont;
+ (UIFont *)inputFont;
+ (UIFont *)settingsTitleFont;
+ (UIFont *)sectionHeaderFont;

@end

NS_ASSUME_NONNULL_END
