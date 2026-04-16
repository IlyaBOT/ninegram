#import <Foundation/Foundation.h>

@class NGDialog;
@class NGMessage;

NS_ASSUME_NONNULL_BEGIN

typedef void (^NGDialogsCompletion)(NSArray<NGDialog *> *dialogs);
typedef void (^NGDialogCompletion)(NGDialog * _Nullable dialog);
typedef void (^NGMessagesCompletion)(NSArray<NGMessage *> *messages);
typedef void (^NGMessageCompletion)(NGMessage * _Nullable message);

@protocol NGDialogListProviding <NSObject>

- (void)fetchDialogsWithCompletion:(NGDialogsCompletion)completion;
- (void)fetchDialogWithIdentifier:(NSString *)identifier completion:(NGDialogCompletion)completion;

@end

@protocol NGConversationProviding <NSObject>

- (void)fetchMessagesForDialogIdentifier:(NSString *)dialogIdentifier completion:(NGMessagesCompletion)completion;
- (void)sendText:(NSString *)text toDialogIdentifier:(NSString *)dialogIdentifier completion:(NGMessageCompletion)completion;

@end

@protocol NGMessagingBackend <NGDialogListProviding, NGConversationProviding>
@end

NS_ASSUME_NONNULL_END
