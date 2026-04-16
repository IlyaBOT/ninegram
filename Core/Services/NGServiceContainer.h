#import <Foundation/Foundation.h>

#import "NGAvatarProviding.h"
#import "NGMessagingBackend.h"

NS_ASSUME_NONNULL_BEGIN

@interface NGServiceContainer : NSObject

@property (nonatomic, strong, readonly) id<NGMessagingBackend> backend;
@property (nonatomic, strong, readonly) id<NGAvatarProviding> avatarProvider;

- (void)clearTransientCaches;

@end

NS_ASSUME_NONNULL_END
