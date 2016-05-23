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
#import "NSDateFormatter+HelperMethods.h"

@implementation ACDueDate

+(ACDueDate *)insertDueDateWithDate:(NSDate *)date
{
    ACDueDate *coreDataDueDate = [SSCoreData insertNewObjectForEntityForName:@"DueDate"];
    coreDataDueDate.date = date;
    [[NSDateFormatter sharedDateFormatter] setDateStyle:NSDateFormatterMediumStyle];
    coreDataDueDate.dateString = [[NSDateFormatter sharedDateFormatter] stringFromDate:date];

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

//+(NSArray *)fetchDueDates {
//    NSArray *dates = [SSCoreData fetchObjectsForEntityForName:@"DueDate" withSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date"
//                                                                                                                        ascending:YES]]];
//    return dates;
//}



+(void)removeDueDates:(NSArray *)dates
{
//    [SSCoreData removeObjects:dates];
    [ACDueDate saveDueDate];
}

-(void)removeDueDate
{
    [ACDueDate removeDueDates:@[self]];
}


@end
