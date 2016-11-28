//
//  NSDate+Agenda.h
//  CalendarIOS7
//
//  Created by Jerome Morissard on 3/3/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Agenda)

- (NSDate *)firstDayOfTheMonth;

- (NSDate *)lastDayOfTheMonth;
- (NSInteger)weekDay;
- (NSInteger)dayComponents;
- (NSInteger)quartComponents;
- (NSInteger)monthComponents;
- (NSInteger)yearComponents;

+ (NSCalendar *)gregorianCalendar;
+ (NSLocale *)locale;

+ (NSInteger)numberOfMonthFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)numberOfDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)numberOfDaysInMonthForDate:(NSDate *)fromDate;

- (BOOL)isToday;
- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *) aDate;
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;

- (NSDate *)startingDate;
- (NSDate *)endingDate;
- (NSString *)dateStringWithFormat:(NSString *)format;
+ (NSArray *)weekdaySymbols;
+ (NSString *)monthSymbolAtIndex:(NSInteger)index;

@end
