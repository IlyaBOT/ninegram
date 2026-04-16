#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NGImageCaching <NSObject>

- (nullable UIImage *)imageForKey:(NSString *)key;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (void)removeAllImages;

@end

NS_ASSUME_NONNULL_END
