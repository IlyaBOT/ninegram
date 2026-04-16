#import "NGMessageLayoutCache.h"

@interface NGMessageLayoutCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation NGMessageLayoutCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 1024;
    }
    return self;
}

- (CGFloat)heightForMessageIdentifier:(NSString *)messageIdentifier width:(CGFloat)width {
    NSString *cacheKey = [self cacheKeyForMessageIdentifier:messageIdentifier width:width];
    NSNumber *height = [self.cache objectForKey:cacheKey];
    return height != nil ? [height doubleValue] : 0.0;
}

- (void)setHeight:(CGFloat)height forMessageIdentifier:(NSString *)messageIdentifier width:(CGFloat)width {
    NSString *cacheKey = [self cacheKeyForMessageIdentifier:messageIdentifier width:width];
    [self.cache setObject:@(height) forKey:cacheKey];
}

- (void)removeAllHeights {
    [self.cache removeAllObjects];
}

- (NSString *)cacheKeyForMessageIdentifier:(NSString *)messageIdentifier width:(CGFloat)width {
    return [NSString stringWithFormat:@"%@-%.0f", messageIdentifier, width];
}

@end
