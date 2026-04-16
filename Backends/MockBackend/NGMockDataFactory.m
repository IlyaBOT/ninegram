#import "NGMockDataFactory.h"

#import "NGDialog.h"
#import "NGMessage.h"

@implementation NGMockDataFactory

+ (NSDictionary<NSString *, NSDictionary *> *)dialogMetadata {
    return @{
        @"anna": @{@"title": @"Anna Petrova", @"letters": @"AP", @"color": @"4E8DF5", @"unread": @2},
        @"design": @{@"title": @"Design Desk", @"letters": @"DD", @"color": @"F28D3B", @"unread": @1},
        @"family": @{@"title": @"Family", @"letters": @"FA", @"color": @"55B36B", @"unread": @4},
        @"alex": @{@"title": @"Alex Mironov", @"letters": @"AM", @"color": @"8B72E6", @"unread": @0},
        @"ops": @{@"title": @"Ops Room", @"letters": @"OR", @"color": @"D85A5A", @"unread": @0},
        @"saved": @{@"title": @"Saved Messages", @"letters": @"SM", @"color": @"2CA6A4", @"unread": @0},
        @"marina": @{@"title": @"Marina", @"letters": @"MA", @"color": @"D275A8", @"unread": @0},
        @"weekend": @{@"title": @"Weekend Ride", @"letters": @"WR", @"color": @"5C8A4D", @"unread": @3}
    };
}

+ (NSArray<NGDialog *> *)seedDialogs {
    NSDictionary *messagesByDialogIdentifier = [self seedMessagesByDialogIdentifier];
    NSDictionary *metadata = [self dialogMetadata];
    NSMutableArray *dialogs = [NSMutableArray array];

    for (NSString *dialogIdentifier in metadata) {
        NSDictionary *dialogInfo = metadata[dialogIdentifier];
        NSArray *messages = messagesByDialogIdentifier[dialogIdentifier];
        NGMessage *lastMessage = [messages lastObject];

        NGDialog *dialog = [[NGDialog alloc] initWithIdentifier:dialogIdentifier
                                                          title:dialogInfo[@"title"]
                                                  avatarLetters:dialogInfo[@"letters"]
                                                 accentColorHex:dialogInfo[@"color"]
                                                lastMessageText:lastMessage.text
                                                lastMessageDate:lastMessage.date
                                                    unreadCount:[dialogInfo[@"unread"] unsignedIntegerValue]];
        [dialogs addObject:dialog];
    }

    [dialogs sortUsingComparator:^NSComparisonResult(NGDialog *leftDialog, NGDialog *rightDialog) {
        return [rightDialog.lastMessageDate compare:leftDialog.lastMessageDate];
    }];

    return [dialogs copy];
}

+ (NSDictionary<NSString *, NSArray<NGMessage *> *> *)seedMessagesByDialogIdentifier {
    NSDate *now = [NSDate date];

    return @{
        @"anna": @[
            [self messageWithIdentifier:@"anna-1" dialogIdentifier:@"anna" minutesAgoFromDate:now minutesAgo:900 text:@"Still on for tomorrow?" outgoing:NO],
            [self messageWithIdentifier:@"anna-2" dialogIdentifier:@"anna" minutesAgoFromDate:now minutesAgo:896 text:@"Yes, around noon works." outgoing:YES],
            [self messageWithIdentifier:@"anna-3" dialogIdentifier:@"anna" minutesAgoFromDate:now minutesAgo:40 text:@"Can you bring the old Lightning cable?" outgoing:NO],
            [self messageWithIdentifier:@"anna-4" dialogIdentifier:@"anna" minutesAgoFromDate:now minutesAgo:38 text:@"I found one in the drawer." outgoing:YES],
            [self messageWithIdentifier:@"anna-5" dialogIdentifier:@"anna" minutesAgoFromDate:now minutesAgo:4 text:@"Perfect, see you soon." outgoing:YES],
            [self messageWithIdentifier:@"anna-6" dialogIdentifier:@"anna" minutesAgoFromDate:now minutesAgo:3 text:@"I can bring a charger too." outgoing:NO]
        ],
        @"design": @[
            [self messageWithIdentifier:@"design-1" dialogIdentifier:@"design" minutesAgoFromDate:now minutesAgo:1400 text:@"Header spacing feels too loose on iPad." outgoing:NO],
            [self messageWithIdentifier:@"design-2" dialogIdentifier:@"design" minutesAgoFromDate:now minutesAgo:80 text:@"Agreed. I can tighten the list rows a bit." outgoing:YES],
            [self messageWithIdentifier:@"design-3" dialogIdentifier:@"design" minutesAgoFromDate:now minutesAgo:27 text:@"Let's keep the classic Telegram density." outgoing:NO]
        ],
        @"family": @[
            [self messageWithIdentifier:@"family-1" dialogIdentifier:@"family" minutesAgoFromDate:now minutesAgo:1600 text:@"Did grandma get the parcel?" outgoing:NO],
            [self messageWithIdentifier:@"family-2" dialogIdentifier:@"family" minutesAgoFromDate:now minutesAgo:1590 text:@"Yes, delivered in the morning." outgoing:YES],
            [self messageWithIdentifier:@"family-3" dialogIdentifier:@"family" minutesAgoFromDate:now minutesAgo:58 text:@"Send a photo when you can." outgoing:NO]
        ],
        @"alex": @[
            [self messageWithIdentifier:@"alex-1" dialogIdentifier:@"alex" minutesAgoFromDate:now minutesAgo:1800 text:@"The old iPad still boots faster than I expected." outgoing:NO],
            [self messageWithIdentifier:@"alex-2" dialogIdentifier:@"alex" minutesAgoFromDate:now minutesAgo:1788 text:@"Good sign. We should keep the view stack small." outgoing:YES],
            [self messageWithIdentifier:@"alex-3" dialogIdentifier:@"alex" minutesAgoFromDate:now minutesAgo:160 text:@"Agreed. No blur, no heavy attachments yet." outgoing:NO]
        ],
        @"ops": @[
            [self messageWithIdentifier:@"ops-1" dialogIdentifier:@"ops" minutesAgoFromDate:now minutesAgo:2880 text:@"Server migration window starts tomorrow." outgoing:NO],
            [self messageWithIdentifier:@"ops-2" dialogIdentifier:@"ops" minutesAgoFromDate:now minutesAgo:1440 text:@"Noted. Keeping the client shell offline for now." outgoing:YES],
            [self messageWithIdentifier:@"ops-3" dialogIdentifier:@"ops" minutesAgoFromDate:now minutesAgo:210 text:@"That keeps the scope sane." outgoing:NO]
        ],
        @"saved": @[
            [self messageWithIdentifier:@"saved-1" dialogIdentifier:@"saved" minutesAgoFromDate:now minutesAgo:3000 text:@"Performance budget: no blur, minimal image cache, fixed-height dialog rows." outgoing:YES],
            [self messageWithIdentifier:@"saved-2" dialogIdentifier:@"saved" minutesAgoFromDate:now minutesAgo:1260 text:@"Next: prototype the real backend boundary." outgoing:YES]
        ],
        @"marina": @[
            [self messageWithIdentifier:@"marina-1" dialogIdentifier:@"marina" minutesAgoFromDate:now minutesAgo:3200 text:@"How far are you with the client shell?" outgoing:NO],
            [self messageWithIdentifier:@"marina-2" dialogIdentifier:@"marina" minutesAgoFromDate:now minutesAgo:3180 text:@"Chats, chat, settings first. Then backend." outgoing:YES],
            [self messageWithIdentifier:@"marina-3" dialogIdentifier:@"marina" minutesAgoFromDate:now minutesAgo:780 text:@"Makes sense. Keep it boring and fast." outgoing:NO]
        ],
        @"weekend": @[
            [self messageWithIdentifier:@"weekend-1" dialogIdentifier:@"weekend" minutesAgoFromDate:now minutesAgo:3600 text:@"Weather looks clear for Saturday." outgoing:NO],
            [self messageWithIdentifier:@"weekend-2" dialogIdentifier:@"weekend" minutesAgoFromDate:now minutesAgo:3570 text:@"Let's meet near the river at 9." outgoing:NO],
            [self messageWithIdentifier:@"weekend-3" dialogIdentifier:@"weekend" minutesAgoFromDate:now minutesAgo:600 text:@"I can bring the pump and tools." outgoing:YES],
            [self messageWithIdentifier:@"weekend-4" dialogIdentifier:@"weekend" minutesAgoFromDate:now minutesAgo:330 text:@"Great, bring water too." outgoing:NO]
        ]
    };
}

+ (NGMessage *)messageWithIdentifier:(NSString *)identifier
                    dialogIdentifier:(NSString *)dialogIdentifier
                  minutesAgoFromDate:(NSDate *)referenceDate
                          minutesAgo:(NSInteger)minutesAgo
                                text:(NSString *)text
                            outgoing:(BOOL)outgoing {
    NSDate *date = [referenceDate dateByAddingTimeInterval:-(minutesAgo * 60.0)];
    return [[NGMessage alloc] initWithIdentifier:identifier
                                dialogIdentifier:dialogIdentifier
                                            text:text
                                            date:date
                                        outgoing:outgoing];
}

@end
