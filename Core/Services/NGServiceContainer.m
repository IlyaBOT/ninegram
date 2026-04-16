#import "NGServiceContainer.h"

#import "NGAvatarProvider.h"
#import "NGImageCaching.h"
#import "NGMemoryImageCache.h"
#import "NGMockMessagingBackend.h"

@interface NGServiceContainer ()

@property (nonatomic, strong) id<NGMessagingBackend> backend;
@property (nonatomic, strong) id<NGAvatarProviding> avatarProvider;
@property (nonatomic, strong) id<NGImageCaching> imageCache;

@end

@implementation NGServiceContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageCache = [[NGMemoryImageCache alloc] init];
        _avatarProvider = [[NGAvatarProvider alloc] initWithImageCache:_imageCache];
        _backend = [[NGMockMessagingBackend alloc] init];
    }
    return self;
}

- (void)clearTransientCaches {
    [self.imageCache removeAllImages];
}

@end
