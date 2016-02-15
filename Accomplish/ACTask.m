//
//  ACTask.n
//  Accomplish
//
//  Created by Shrijit Singh on 05/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import "ACTask.h"
#import "ACCategory.h"
#import "ACDueDate.h"
#import "UIApplication+CoreData.h"
#import "ACPriority.h"

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
	coreDataTask.priority = [NSNumber numberWithInt:serial];
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
    sortedTasks = [ACCategory arrangeTasks:sortedTasks byCategory:category];
    sortedTasks = [ACDueDate arrangeByDueDate:sortedTasks];
    sortedTasks = [ACPriority arrangeByPriority:sortedTasks];
    return sortedTasks;
}

@end
