//
//  ACReminderDate.m
//  Accomplish
//
//  Created by Shrijit Singh on 10/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACReminder.h"

@implementation ACReminder

-(id)initWithReminderDate:(NSDate *)aDate
{
    self = [super init];
    
    _date = aDate;
    if (aDate == nil)
    {
        _dateString = @"";
        _isEnabled = NO;
    }
    else
    {
        _dateString = [[ACReminder dateFormat] stringFromDate:aDate];
        _isEnabled = YES;
    }
    
    return self;
}

+(NSDateFormatter *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, hh:mm a"];
    
    return dateFormatter;
}

@end