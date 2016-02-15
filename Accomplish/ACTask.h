//
//  ACTask.h
//  Accomplish
//
//  Created by Shrijit Singh on 05/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSCoreData.h"

@class ACCategory;
@class ACDueDate;

NS_ASSUME_NONNULL_BEGIN


@interface ACTask : NSManagedObject

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

+(NSEntityDescription *)entity;
+(ACTask *)insertTaskWithName:(NSString *)name details:(NSString *)details serial:(int)serial priority:(int)priority dueDate:(ACDueDate *)dueDate reminderDate:(NSDate *)reminderDate isCompleted:(BOOL)completed intoCategory:(ACCategory *)category;
+(NSArray *)fetchTasks;
+(void)changeCategorySequenceforTasks:(NSArray *)tasks;
+(void)saveTasks;
+(void)removeTasks:(NSArray *)tasks;
-(void)removeTask;
+(NSMutableArray *)tasks:(NSMutableArray *)tasks ofCategory:(ACCategory *)category;

@end

NS_ASSUME_NONNULL_END

#import "ACTask+CoreDataProperties.h"
