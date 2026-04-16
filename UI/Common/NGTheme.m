#import "NGTheme.h"

@implementation NGTheme

+ (void)applyGlobalAppearance {
    NSDictionary *titleAttributes = @{
        NSForegroundColorAttributeName: [self primaryTextColor],
        NSFontAttributeName: [self navigationTitleFont]
    };

    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.barTintColor = [self surfaceColor];
    navigationBar.tintColor = [self accentColor];
    navigationBar.translucent = NO;
    [navigationBar setTitleTextAttributes:titleAttributes];

    UITabBar *tabBar = [UITabBar appearance];
    tabBar.barTintColor = [self surfaceColor];
    tabBar.tintColor = [self accentColor];
    tabBar.translucent = NO;
}

+ (UIColor *)backgroundColor {
    return [self colorWithHex:@"F2F5F7"];
}

+ (UIColor *)surfaceColor {
    return [UIColor whiteColor];
}

+ (UIColor *)separatorColor {
    return [self colorWithHex:@"E1E6EA"];
}

+ (UIColor *)accentColor {
    return [self colorWithHex:@"2795F0"];
}

+ (UIColor *)primaryTextColor {
    return [self colorWithHex:@"17212B"];
}

+ (UIColor *)secondaryTextColor {
    return [self colorWithHex:@"7F8A96"];
}

+ (UIColor *)unreadBadgeColor {
    return [self colorWithHex:@"49A8F6"];
}

+ (UIColor *)incomingBubbleColor {
    return [UIColor whiteColor];
}

+ (UIColor *)outgoingBubbleColor {
    return [self colorWithHex:@"DDEFFF"];
}

+ (UIColor *)bubbleBorderColor {
    return [self colorWithHex:@"D9E1E7"];
}

+ (UIColor *)inputFieldBackgroundColor {
    return [self colorWithHex:@"EEF2F5"];
}

+ (UIColor *)placeholderTextColor {
    return [self colorWithHex:@"A1ABB4"];
}

+ (UIColor *)headerPillColor {
    return [self colorWithHex:@"E3E8ED"];
}

+ (UIFont *)navigationTitleFont {
    return [self fontNamed:@"HelveticaNeue-Medium" fallback:[UIFont boldSystemFontOfSize:17.0] size:17.0];
}

+ (UIFont *)dialogTitleFont {
    return [self fontNamed:@"HelveticaNeue-Medium" fallback:[UIFont boldSystemFontOfSize:16.0] size:16.0];
}

+ (UIFont *)dialogPreviewFont {
    return [self fontNamed:@"HelveticaNeue" fallback:[UIFont systemFontOfSize:14.0] size:14.0];
}

+ (UIFont *)dialogTimestampFont {
    return [self fontNamed:@"HelveticaNeue" fallback:[UIFont systemFontOfSize:12.0] size:12.0];
}

+ (UIFont *)badgeFont {
    return [self fontNamed:@"HelveticaNeue-Bold" fallback:[UIFont boldSystemFontOfSize:12.0] size:12.0];
}

+ (UIFont *)messageFont {
    return [self fontNamed:@"HelveticaNeue" fallback:[UIFont systemFontOfSize:16.0] size:16.0];
}

+ (UIFont *)inputFont {
    return [self fontNamed:@"HelveticaNeue" fallback:[UIFont systemFontOfSize:16.0] size:16.0];
}

+ (UIFont *)settingsTitleFont {
    return [self fontNamed:@"HelveticaNeue" fallback:[UIFont systemFontOfSize:16.0] size:16.0];
}

+ (UIFont *)sectionHeaderFont {
    return [self fontNamed:@"HelveticaNeue-Medium" fallback:[UIFont boldSystemFontOfSize:12.0] size:12.0];
}

+ (UIColor *)colorWithHex:(NSString *)hexString {
    NSString *cleanHex = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    unsigned int value = 0;
    [[NSScanner scannerWithString:cleanHex] scanHexInt:&value];

    return [UIColor colorWithRed:((value >> 16) & 0xFF) / 255.0
                           green:((value >> 8) & 0xFF) / 255.0
                            blue:(value & 0xFF) / 255.0
                           alpha:1.0];
}

+ (UIFont *)fontNamed:(NSString *)fontName fallback:(UIFont *)fallback size:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:fontName size:size];
    return font != nil ? font : fallback;
}

@end
