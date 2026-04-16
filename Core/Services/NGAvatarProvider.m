#import "NGAvatarProvider.h"

#import "NGDialog.h"

@interface NGAvatarProvider ()

@property (nonatomic, strong) id<NGImageCaching> imageCache;
@property (nonatomic) dispatch_queue_t renderQueue;

@end

@implementation NGAvatarProvider

- (instancetype)initWithImageCache:(id<NGImageCaching>)imageCache {
    self = [super init];
    if (self) {
        _imageCache = imageCache;
        _renderQueue = dispatch_queue_create("com.ninegram.avatar-render", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)avatarForDialog:(NGDialog *)dialog diameter:(CGFloat)diameter completion:(NGAvatarCompletion)completion {
    NSString *cacheKey = [NSString stringWithFormat:@"%@-%.0f-%@-%@", dialog.identifier, diameter, dialog.avatarLetters, dialog.accentColorHex];
    UIImage *cachedImage = [self.imageCache imageForKey:cacheKey];
    if (cachedImage != nil) {
        completion(cachedImage);
        return;
    }

    dispatch_async(self.renderQueue, ^{
        UIImage *renderedImage = [self renderAvatarForDialog:dialog diameter:diameter];
        [self.imageCache setImage:renderedImage forKey:cacheKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(renderedImage);
        });
    });
}

- (UIImage *)renderAvatarForDialog:(NGDialog *)dialog diameter:(CGFloat)diameter {
    CGSize size = CGSizeMake(diameter, diameter);
    CGRect bounds = CGRectMake(0.0, 0.0, diameter, diameter);
    UIColor *fillColor = [self colorFromHexString:dialog.accentColorHex];
    UIFont *font = [UIFont boldSystemFontOfSize:MAX(12.0, floor(diameter * 0.38))];
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };
    CGSize textSize = [dialog.avatarLetters sizeWithAttributes:attributes];
    CGRect textRect = CGRectMake(floor((diameter - textSize.width) * 0.5),
                                 floor((diameter - textSize.height) * 0.5),
                                 ceil(textSize.width),
                                 ceil(textSize.height));

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillEllipseInRect(context, bounds);
    [dialog.avatarLetters drawInRect:textRect withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanHex = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if (cleanHex.length != 6) {
        return [UIColor colorWithWhite:0.65 alpha:1.0];
    }

    unsigned int hexValue = 0;
    [[NSScanner scannerWithString:cleanHex] scanHexInt:&hexValue];

    CGFloat red = ((hexValue >> 16) & 0xFF) / 255.0;
    CGFloat green = ((hexValue >> 8) & 0xFF) / 255.0;
    CGFloat blue = (hexValue & 0xFF) / 255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
