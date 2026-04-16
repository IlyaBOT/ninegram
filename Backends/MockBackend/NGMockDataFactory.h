#import <Foundation/Foundation.h>

@class NGDialog;
@class NGMessage;

NS_ASSUME_NONNULL_BEGIN

@interface NGMockDataFactory : NSObject

+ (NSArray<NGDialog *> *)seedDialogs;
+ (NSDictionary<NSString *, NSArray<NGMessage *> *> *)seedMessagesByDialogIdentifier;

@end

NS_ASSUME_NONNULL_END
