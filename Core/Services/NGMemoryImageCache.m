#import "NGMemoryImageCache.h"

@interface NGMemoryImageCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation NGMemoryImageCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 128;
        _cache.totalCostLimit = 4 * 1024 * 1024;
    }
    return self;
}

- (UIImage *)imageForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    NSUInteger cost = 1;
    if (image.CGImage != NULL) {
        cost = (NSUInteger)(CGImageGetBytesPerRow(image.CGImage) * CGImageGetHeight(image.CGImage));
    }

    [self.cache setObject:image forKey:key cost:cost];
}

- (void)removeAllImages {
    [self.cache removeAllObjects];
}

@end
