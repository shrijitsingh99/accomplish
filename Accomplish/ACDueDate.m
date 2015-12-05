//
//  ACDueDate.m
//  Accomplish
//
//  Created by Shrijit Singh on 21/11/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACDueDate.h"

@implementation ACDueDate

-(id)initWithDueDate:(NSDate *)aDate
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
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateIntervalFormatterMediumStyle;
        _dateString = [dateFormatter stringFromDate:aDate];
        _isEnabled = YES;
    }
    
    return self;
}

+(NSDateFormatter *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    return dateFormatter;
}

@end
