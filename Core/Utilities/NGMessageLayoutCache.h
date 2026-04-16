#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NGMessageLayoutCache : NSObject

- (CGFloat)heightForMessageIdentifier:(NSString *)messageIdentifier width:(CGFloat)width;
- (void)setHeight:(CGFloat)height forMessageIdentifier:(NSString *)messageIdentifier width:(CGFloat)width;
- (void)removeAllHeights;

@end

NS_ASSUME_NONNULL_END
