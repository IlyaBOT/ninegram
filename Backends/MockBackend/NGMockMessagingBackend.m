#import "NGMockMessagingBackend.h"

#import "NGDialog.h"
#import "NGMessage.h"
#import "NGMockDataFactory.h"

@interface NGMockMessagingBackend ()

@property (nonatomic) dispatch_queue_t backendQueue;
@property (nonatomic, strong) NSMutableArray *dialogs;
@property (nonatomic, strong) NSMutableDictionary *messagesByDialogIdentifier;

@end

@implementation NGMockMessagingBackend

- (instancetype)init {
    self = [super init];
    if (self) {
        _backendQueue = dispatch_queue_create("com.ninegram.mock-backend", DISPATCH_QUEUE_SERIAL);
        NSArray *seedDialogs = [NGMockDataFactory seedDialogs];
        _dialogs = seedDialogs != nil ? [seedDialogs mutableCopy] : [NSMutableArray array];
        _messagesByDialogIdentifier = [NSMutableDictionary dictionary];

        NSDictionary *seedMessages = [NGMockDataFactory seedMessagesByDialogIdentifier];
        [seedMessages enumerateKeysAndObjectsUsingBlock:^(NSString *dialogIdentifier, NSArray *messages, BOOL *stop) {
            self.messagesByDialogIdentifier[dialogIdentifier] = [messages mutableCopy];
        }];
    }
    return self;
}

- (void)fetchDialogsWithCompletion:(NGDialogsCompletion)completion {
    dispatch_async(self.backendQueue, ^{
        NSArray *sortedDialogs = [self sortedDialogsSnapshot];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(sortedDialogs);
        });
    });
}

- (void)fetchDialogWithIdentifier:(NSString *)identifier completion:(NGDialogCompletion)completion {
    dispatch_async(self.backendQueue, ^{
        NGDialog *match = nil;
        for (NGDialog *dialog in self.dialogs) {
            if ([dialog.identifier isEqualToString:identifier]) {
                match = dialog;
                break;
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(match);
        });
    });
}

- (void)fetchMessagesForDialogIdentifier:(NSString *)dialogIdentifier completion:(NGMessagesCompletion)completion {
    dispatch_async(self.backendQueue, ^{
        NSArray *messages = [self sortedMessagesForDialogIdentifier:dialogIdentifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(messages);
        });
    });
}

- (void)sendText:(NSString *)text toDialogIdentifier:(NSString *)dialogIdentifier completion:(NGMessageCompletion)completion {
    dispatch_async(self.backendQueue, ^{
        NSMutableArray *messages = self.messagesByDialogIdentifier[dialogIdentifier];
        if (messages == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
            return;
        }

        NGMessage *message = [[NGMessage alloc] initWithIdentifier:[[NSUUID UUID] UUIDString]
                                                  dialogIdentifier:dialogIdentifier
                                                              text:text
                                                              date:[NSDate date]
                                                          outgoing:YES];
        [messages addObject:message];

        NSUInteger dialogIndex = NSNotFound;
        NGDialog *dialog = nil;
        for (NSUInteger index = 0; index < self.dialogs.count; index++) {
            NGDialog *candidate = self.dialogs[index];
            if ([candidate.identifier isEqualToString:dialogIdentifier]) {
                dialogIndex = index;
                dialog = candidate;
                break;
            }
        }

        if (dialog != nil && dialogIndex != NSNotFound) {
            NGDialog *updatedDialog = [dialog dialogByUpdatingLastMessageText:text
                                                              lastMessageDate:message.date
                                                                  unreadCount:0];
            [self.dialogs replaceObjectAtIndex:dialogIndex withObject:updatedDialog];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(message);
        });
    });
}

- (NSArray *)sortedDialogsSnapshot {
    NSArray *dialogsCopy = [self.dialogs copy];
    return [dialogsCopy sortedArrayUsingComparator:^NSComparisonResult(NGDialog *leftDialog, NGDialog *rightDialog) {
        return [rightDialog.lastMessageDate compare:leftDialog.lastMessageDate];
    }];
}

- (NSArray *)sortedMessagesForDialogIdentifier:(NSString *)dialogIdentifier {
    NSArray *storedMessages = [[self.messagesByDialogIdentifier objectForKey:dialogIdentifier] copy];
    NSArray *messages = storedMessages != nil ? storedMessages : @[];
    return [messages sortedArrayUsingComparator:^NSComparisonResult(NGMessage *leftMessage, NGMessage *rightMessage) {
        return [leftMessage.date compare:rightMessage.date];
    }];
}

@end
