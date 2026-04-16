#import "NGDialog.h"

@implementation NGDialog

- (instancetype)initWithIdentifier:(NSString *)identifier
                             title:(NSString *)title
                     avatarLetters:(NSString *)avatarLetters
                    accentColorHex:(NSString *)accentColorHex
                   lastMessageText:(NSString *)lastMessageText
                   lastMessageDate:(NSDate *)lastMessageDate
                       unreadCount:(NSUInteger)unreadCount {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _title = [title copy];
        _avatarLetters = [avatarLetters copy];
        _accentColorHex = [accentColorHex copy];
        _lastMessageText = [lastMessageText copy];
        _lastMessageDate = lastMessageDate;
        _unreadCount = unreadCount;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NGDialog *)dialogByUpdatingLastMessageText:(NSString *)lastMessageText
                              lastMessageDate:(NSDate *)lastMessageDate
                                  unreadCount:(NSUInteger)unreadCount {
    return [[NGDialog alloc] initWithIdentifier:self.identifier
                                          title:self.title
                                  avatarLetters:self.avatarLetters
                                 accentColorHex:self.accentColorHex
                                lastMessageText:lastMessageText
                                lastMessageDate:lastMessageDate
                                    unreadCount:unreadCount];
}

@end
