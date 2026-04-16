#import "NGDateFormatting.h"

@implementation NGDateFormatting

+ (NSDate *)startOfDayForDate:(NSDate *)date {
    return [[NSCalendar currentCalendar] startOfDayForDate:date];
}

+ (NSString *)dialogListTimestampStringForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];

    if ([calendar isDateInToday:date]) {
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:date];
    }

    NSDate *startOfToday = [calendar startOfDayForDate:[NSDate date]];
    NSDate *startOfDate = [calendar startOfDayForDate:date];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:startOfDate toDate:startOfToday options:0];

    if (components.day < 7) {
        [formatter setDateFormat:@"EEE"];
        return [[formatter stringFromDate:date] capitalizedString];
    }

    [formatter setDateFormat:@"dd.MM.yy"];
    return [formatter stringFromDate:date];
}

+ (NSString *)chatSectionTitleForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];

    if ([calendar isDateInToday:date]) {
        return @"Today";
    }

    if ([calendar isDateInYesterday:date]) {
        return @"Yesterday";
    }

    [formatter setDateFormat:@"d MMMM"];
    return [formatter stringFromDate:date];
}

@end
