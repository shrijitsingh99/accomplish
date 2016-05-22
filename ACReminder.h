//
//  ACReminder.h
//  Accomplish
//
//  Created by Shrijit Singh on 22/05/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ACTask;

NS_ASSUME_NONNULL_BEGIN

@interface ACReminder : NSManagedObject

+(ACReminder *)insertReminderWithDate:(NSDate *)date repeatInterval:(int)interval;
+(void)saveReminder;
+(NSArray *)fetchReminder;
+(void)removeReminders:(NSArray *)reminders;
-(void)removeReminder;
+(NSDateFormatter *)dateFormat;

@end

NS_ASSUME_NONNULL_END

#import "ACReminder+CoreDataProperties.h"
