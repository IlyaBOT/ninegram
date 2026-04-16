#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NGMessage : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *dialogIdentifier;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, assign, readonly, getter=isOutgoing) BOOL outgoing;

- (instancetype)initWithIdentifier:(NSString *)identifier
                  dialogIdentifier:(NSString *)dialogIdentifier
                              text:(NSString *)text
                              date:(NSDate *)date
                          outgoing:(BOOL)outgoing NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
