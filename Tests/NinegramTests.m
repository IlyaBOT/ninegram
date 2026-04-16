#import <XCTest/XCTest.h>

#import "NGDialog.h"
#import "NGMessage.h"
#import "NGMockMessagingBackend.h"

@interface NinegramTests : XCTestCase
@end

@implementation NinegramTests

- (void)testDialogsAreSortedByMostRecentMessage {
    NGMockMessagingBackend *backend = [[NGMockMessagingBackend alloc] init];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch dialogs"];

    [backend fetchDialogsWithCompletion:^(NSArray<NGDialog *> *dialogs) {
        XCTAssertTrue(dialogs.count > 1);

        for (NSUInteger index = 1; index < dialogs.count; index++) {
            NGDialog *previousDialog = dialogs[index - 1];
            NGDialog *currentDialog = dialogs[index];
            XCTAssertTrue([previousDialog.lastMessageDate compare:currentDialog.lastMessageDate] != NSOrderedAscending);
        }

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testSendTextAppendsOutgoingMessage {
    NGMockMessagingBackend *backend = [[NGMockMessagingBackend alloc] init];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Send message"];
    __block NSUInteger originalCount = 0;

    [backend fetchMessagesForDialogIdentifier:@"anna" completion:^(NSArray<NGMessage *> *messages) {
        originalCount = messages.count;

        [backend sendText:@"Legacy build smoke test." toDialogIdentifier:@"anna" completion:^(NGMessage *message) {
            XCTAssertNotNil(message);
            XCTAssertTrue(message.isOutgoing);
            XCTAssertEqualObjects(message.text, @"Legacy build smoke test.");

            [backend fetchMessagesForDialogIdentifier:@"anna" completion:^(NSArray<NGMessage *> *updatedMessages) {
                XCTAssertEqual(updatedMessages.count, originalCount + 1);
                XCTAssertEqualObjects(((NGMessage *)[updatedMessages lastObject]).text, @"Legacy build smoke test.");
                [expectation fulfill];
            }];
        }];
    }];

    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

@end
