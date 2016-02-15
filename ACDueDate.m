//
//  ACDueDate.m
//  Accomplish
//
//  Created by Shrijit Singh on 14/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import "ACDueDate.h"
#import "ACTask.h"
#import "SSCoreData.h"
#import "UIApplication+CoreData.h"

@implementation ACDueDate

+(ACDueDate *)insertDueDateWithDate:(NSDate *)date
{
    ACDueDate *coreDataDueDate = [SSCoreData insertNewObjectForEntityForName:@"DueDate"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    coreDataDueDate.date = [formatter stringFromDate:date];
    [formatter setDateFormat:@"hh-mm-ss"];
    coreDataDueDate.time = [formatter stringFromDate:date];
    [ACDueDate saveDueDate];
    
    return coreDataDueDate;
}

+(void)saveDueDate
{
    NSError *error = nil;
    if (![[UIApplication applicationManagedObjectContext] save:&error])
    {
        NSLog(@"Error occured while saving category");
    }
}

+(NSArray *)fetchDueDates {
    NSArray *dates = [SSCoreData fetchObjectsForEntityForName:@"DueDate" withSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                                                        ascending:YES]]];
    return dates;
}

+(NSMutableArray *)arrangeByDueDate:(NSMutableArray *)tasks
{
    [tasks sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dueDate.date" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"dueDate.time" ascending:YES]]];
    return tasks;
}

+(NSMutableArray *)arrangeByDueDateIntoSections:(NSMutableArray *)dates
{
    NSMutableArray *taskSortedIntoSections = [[NSMutableArray alloc] init];
    for (ACDueDate *date in dates)
    {
        [taskSortedIntoSections addObject:date.task];
    }
    return taskSortedIntoSections;
}

@end
