//
//  ACReminder.m
//  Accomplish
//
//  Created by Shrijit Singh on 22/05/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import "ACReminder.h"
#import "ACTask.h"
#import "SSCoreData.h"
#import "UIApplication+CoreData.h"
#import "NSDateFormatter+HelperMethods.h"

@implementation ACReminder

+(ACReminder *)insertReminderWithDate:(NSDate *)date repeatInterval:(int)interval
{
    ACReminder *coreDataReminder = [SSCoreData insertNewObjectForEntityForName:@"Reminder"];
    coreDataReminder.date = date;
    [[NSDateFormatter sharedDateFormatter] setTimeStyle:NSDateFormatterShortStyle];
    coreDataReminder.timeString = [[NSDateFormatter sharedDateFormatter] stringFromDate:date];
    [[NSDateFormatter sharedDateFormatter] setDateStyle:NSDateFormatterMediumStyle];
    coreDataReminder.dateString = [[NSDateFormatter sharedDateFormatter] stringFromDate:date];
    
    [ACReminder saveReminder];
    
    return coreDataReminder;
}

+(void)saveReminder
{
    NSError *error = nil;
    if (![[UIApplication applicationManagedObjectContext] save:&error])
    {
        NSLog(@"Error occured while saving category");
    }
}

+(NSArray *)fetchReminder
{
    NSArray *reminders = [SSCoreData fetchObjectsForEntityForName:@"Reminders" withSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                                                           ascending:YES]]];
    return reminders;
}

+(void)removeReminders:(NSArray *)reminders
{
    [SSCoreData removeObjects:reminders];
    [ACReminder saveReminder];
}

-(void)removeReminder
{
    [ACReminder removeReminders:@[self]];
}

+(NSDateFormatter *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, hh:mm a"];
    return dateFormatter;
}

@end
