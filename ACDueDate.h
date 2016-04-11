//
//  ACDueDate.h
//  Accomplish
//
//  Created by Shrijit Singh on 14/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ACTask;

NS_ASSUME_NONNULL_BEGIN

@interface ACDueDate : NSManagedObject

+(ACDueDate *)insertDueDateWithDate:(NSDate *)date;
+(void)saveDueDate;
+(NSArray *)fetchDueDates;
+(NSMutableArray *)arrangeByDueDate:(NSMutableArray *)tasks;
+(NSMutableArray *)arrangeTasks:(NSMutableArray *)tasks byDueDateIntoSections:(NSMutableArray *)dates;

@end

NS_ASSUME_NONNULL_END

#import "ACDueDate+CoreDataProperties.h"
