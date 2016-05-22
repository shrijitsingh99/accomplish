//
//  ACTask.m
//  Accomplish
//
//  Created by Shrijit Singh on 05/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import "ACTask.h"
#import "ACCategory.h"
#import "ACDueDate.h"
#import "UIApplication+CoreData.h"
#import "ACPushNotification.h"

@implementation ACTask

@synthesize dateFormatter = _dateFormatter;

+(NSEntityDescription *)entity {
	return [NSEntityDescription entityForName:@"Task" inManagedObjectContext:[UIApplication applicationManagedObjectContext]];
}


+(ACTask *)insertTaskWithName:(NSString *)name details:(NSString *)details serial:(int)serial priority:(int)priority dueDate:(ACDueDate *)dueDate reminderDate:(NSDate *)reminderDate isCompleted:(BOOL)completed intoCategory:(ACCategory *)category
{

	ACTask *coreDataTask = [SSCoreData insertNewObjectForEntityForName:@"Task"];
	coreDataTask.name = name;
	coreDataTask.details = details;
	coreDataTask.serial = [NSNumber numberWithInt:serial];
	coreDataTask.priority = [NSNumber numberWithInt:priority];
	coreDataTask.dueDate = dueDate;
	coreDataTask.reminderDate = reminderDate;
	coreDataTask.completed = [NSNumber numberWithBool:completed];
    coreDataTask.category = category;
	[ACTask saveTasks];
	return coreDataTask;
}

+(void)saveTasks {
	NSError *error = nil;
	if (![[UIApplication applicationManagedObjectContext] save:&error]) {
		NSLog(@"Error occured while saving category");
	}

}

+(NSArray *)fetchTasks {
	NSArray *tasks = [SSCoreData fetchObjectsForEntityForName:@"Task" withSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"dueDate.date"
	                                                                                       ascending:NO], [[NSSortDescriptor alloc] initWithKey:@"serial"
	                                                                                                       ascending:NO]]];
	return tasks;
}
-(void)removeTask {
	[ACTask removeTasks:@[self]];
}

+(void)removeTasks:(NSArray *)tasks {
	[SSCoreData removeObjects:tasks];
	[ACTask saveTasks];

}

+(void)changeCategorySequenceforTasks:(NSArray *)tasks {
	NSArray *fetchedTasks = [ACTask fetchTasks];
	for (ACCategory *fetchedTask in fetchedTasks) {
		ACCategory *identicalTask = [tasks objectAtIndex:[tasks indexOfObjectIdenticalTo:fetchedTask]];;
		fetchedTask.serial= identicalTask.serial;
	}
	[ACCategory saveCategories];
}

+(NSMutableArray *)tasks:(NSMutableArray *)tasks ofCategory:(ACCategory *)category
{
    NSMutableArray *sortedTasks = tasks;
    sortedTasks = [self arrangeTasks:sortedTasks byCategory:category];
    sortedTasks = [self arrangeByDueDate:sortedTasks];
    sortedTasks = [self arrangeByPriority:sortedTasks];
    return sortedTasks;
}

+(NSMutableArray *)arrangeByPriority:(NSMutableArray *)tasks
{
    [tasks sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO]]];
    return tasks;
}

+(NSMutableArray *)arrangeByDueDate:(NSMutableArray *)tasks
{
//    [tasks sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dueDate.date" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"dueDate.time" ascending:YES]]];
    return tasks;
}

+(NSMutableArray *)arrangeTasks:(NSMutableArray *)tasks byDueDateIntoSections:(NSMutableArray *)dates
{
    NSMutableArray *taskSortedIntoSections = [[NSMutableArray alloc] init];
    for (ACDueDate *date in dates)
    {
        NSPredicate *filterByDatePredicate = [NSPredicate predicateWithFormat:@"dueDate.dateString CONTAINS %@", date.dateString];
        [taskSortedIntoSections addObject:[[tasks filteredArrayUsingPredicate:filterByDatePredicate] mutableCopy]];
    }
    return taskSortedIntoSections;
}

+(NSMutableArray *)arrangeTasks:(NSMutableArray *)tasks byCategory:(ACCategory *)category
{
    NSPredicate  *filterByCategory = [NSPredicate predicateWithFormat:@"category.name CONTAINS %@", category.name];
    NSMutableArray *tasksArrangeByCategory = [[tasks filteredArrayUsingPredicate:filterByCategory] mutableCopy];
    return tasksArrangeByCategory;
}
@end
