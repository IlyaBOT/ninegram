#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NGDialog : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *avatarLetters;
@property (nonatomic, copy, readonly) NSString *accentColorHex;
@property (nonatomic, copy, readonly) NSString *lastMessageText;
@property (nonatomic, strong, readonly) NSDate *lastMessageDate;
@property (nonatomic, assign, readonly) NSUInteger unreadCount;

- (instancetype)initWithIdentifier:(NSString *)identifier
                             title:(NSString *)title
                     avatarLetters:(NSString *)avatarLetters
                    accentColorHex:(NSString *)accentColorHex
                   lastMessageText:(NSString *)lastMessageText
                   lastMessageDate:(NSDate *)lastMessageDate
                       unreadCount:(NSUInteger)unreadCount NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (NGDialog *)dialogByUpdatingLastMessageText:(NSString *)lastMessageText
                              lastMessageDate:(NSDate *)lastMessageDate
                                  unreadCount:(NSUInteger)unreadCount;

@end

NS_ASSUME_NONNULL_END
