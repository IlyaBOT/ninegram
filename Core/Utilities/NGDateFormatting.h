#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NGDateFormatting : NSObject

+ (NSDate *)startOfDayForDate:(NSDate *)date;
+ (NSString *)dialogListTimestampStringForDate:(NSDate *)date;
+ (NSString *)chatSectionTitleForDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
