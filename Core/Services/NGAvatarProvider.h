#import <Foundation/Foundation.h>

#import "NGAvatarProviding.h"
#import "NGImageCaching.h"

NS_ASSUME_NONNULL_BEGIN

@interface NGAvatarProvider : NSObject <NGAvatarProviding>

- (instancetype)initWithImageCache:(id<NGImageCaching>)imageCache;

@end

NS_ASSUME_NONNULL_END
