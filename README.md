## HYYCalendar
一个简单易用的日期的选择的控件，支持日历选择和Picker选择两种方式。支持iOS 6+

##效果图
<img src="https://github.com/kRadius/HYYCalendar/blob/master/HYYCalendar/HYYCalendar/demo.gif" alt="效果图" width="375"/>

##用法
```objc
#import "HYYCalendar.h"
#import "HYYCalendar+Helper.h"
```
    
```objc
HYYCalendar *calendar = [[HYYCalendar alloc] initWithFrame:self.navigationController.view.bounds number:self.number unit:self.unit type:HYYCalendarTypeCollection];
calendar.delegate = self;
[self.navigationController.view addSubview:calendar];
[calendar show];
```


```objc
#pragma mark - HYYCalendarDelegate
- (void)calendar:(HYYCalendar *)calendar didSelectDate:(NSDate *)date number:(NSUInteger)number unit:(HYYCalendarUnit)unit {
    self.number = number;
    self.unit = unit;
    NSString *dateString = [[NSString stringWithFormat:@"%ld%@后", number, [calendar unitString]] stringByAppendingFormat:@"（%@）", [date dateStringWithFormat:@"yyyy-MM-dd"]];
    self.selectedDateLabel.text = dateString;
}

```


#### License

MIT - Copyright (c) 2016 kRadius
