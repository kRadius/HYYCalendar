//
//  NSDate+Agenda.m
//  CalendarIOS7
//
//  Created by Jerome Morissard on 3/3/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import "NSDate+Agenda.h"
#import <objc/runtime.h>

const char * const JmoCalendarStoreKey = "jmo.calendar";
const char * const JmoLocaleStoreKey = "jmo.locale";

@implementation NSDate (Agenda)

#pragma mark - Getter and Setter

+ (void)setGregorianCalendar:(NSCalendar *)gregorianCalendar
{
    objc_setAssociatedObject(self, JmoCalendarStoreKey, gregorianCalendar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSCalendar *)gregorianCalendar
{
    NSCalendar* cal = objc_getAssociatedObject(self, JmoCalendarStoreKey);
    if (nil == cal) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        
        cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        cal.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        //从周一开始算，默认周日
        [cal setFirstWeekday:2];
        [cal setLocale:[self locale]];
        [self setGregorianCalendar:cal];
        
    }
    return cal;
}

+ (void)setLocal:(NSLocale *)locale
{
    objc_setAssociatedObject(self, JmoLocaleStoreKey, locale, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSLocale *)locale
{
    NSLocale *locale  = objc_getAssociatedObject(self, JmoLocaleStoreKey);
    if (nil == locale) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        [self setLocal:locale];
    }
    return locale;
}

#pragma mark -

- (NSDate *)firstDayOfTheMonth
{
    NSCalendar *gregorian = [self.class gregorianCalendar];
    NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [comps setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comps];
    return firstDayOfMonthDate;
    
//    NSDate *startDate = nil;
//    
//    BOOL ok = [gregorian rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
//    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
//    return startDate;
}

- (NSDate *)lastDayOfTheMonth
{
    NSCalendar *gregorian = [self.class gregorianCalendar];
    NSDateComponents* comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:self];
    
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *lastDayOfMonthDate = [gregorian dateFromComponents:comps];
    return lastDayOfMonthDate;
}

+ (NSInteger)numberOfMonthFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *gregorian = [self gregorianCalendar];
    return [gregorian components:NSMonthCalendarUnit fromDate:fromDate toDate:toDate options:0].month+1;
}

+ (NSInteger)numberOfDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *gregorian = [self gregorianCalendar];
    NSDate *date1;
    NSDate *date2;
    
    //去掉时分秒
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&date1 interval:NULL forDate:fromDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&date2 interval:NULL forDate:toDate];
    
    return [gregorian components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0].day;
}

+ (NSInteger)numberOfDaysInMonthForDate:(NSDate *)fromDate
{
    NSCalendar *gregorian = [self gregorianCalendar];
    NSRange range = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:fromDate];
    
    return range.length;
}

- (NSInteger)weekDay
{
    NSCalendar *gregorian = [self.class gregorianCalendar];
//    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
//    NSInteger weekday = [comps weekday];
//    return weekday ;
    return [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (BOOL)isToday
{
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *otherDay = [calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        return YES;
    }
    return NO;
}

- (BOOL) isEarlierThanDate:(NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate:(NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [[self.class gregorianCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[self.class gregorianCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (NSDate *) dateAtStartOfDay
{
    NSDateComponents *components = [[self.class gregorianCalendar] components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[self.class gregorianCalendar] dateFromComponents:components];
}

- (NSInteger)quartComponents
{
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *comps = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:self];
    return comps.hour*4+(comps.minute/15);
}

- (NSInteger)dayComponents
{
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *comps = [calendar components: NSDayCalendarUnit fromDate:self];
    return comps.day;
}


- (NSInteger)monthComponents
{
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *comps = [calendar components: NSMonthCalendarUnit fromDate:self];
    return comps.month;
}

- (NSInteger)yearComponents
{
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *comps = [calendar components: NSYearCalendarUnit fromDate:self];
    return comps.year;
}

- (NSDate *)startingDate
{
    NSDateComponents *components = [[NSDate gregorianCalendar] components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate gregorianCalendar] dateFromComponents:components];
}

- (NSDate *)endingDate
{
    NSDateComponents *components = [[NSDate gregorianCalendar] components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[NSDate gregorianCalendar] dateFromComponents:components];
}
- (NSString *)dateStringWithFormat:(NSString *)format
{
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    [datef setDateFormat:format];
    return [datef stringFromDate:self];
}
+ (NSArray *)weekdaySymbols
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableArray *upper = [NSMutableArray new];
    for (NSString *day in [dateFormatter shortWeekdaySymbols]) {
        [upper addObject:day.uppercaseString];
    }
    return  upper;
}

+ (NSString *)monthSymbolAtIndex:(NSInteger)index
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *months = [dateFormatter monthSymbols];
    return months[index - 1];
}
#pragma clang diagnostic pop

@end
