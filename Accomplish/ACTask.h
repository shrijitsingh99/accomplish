//
//  ACTask.h
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACCategory.h"
#import "ACPriority.h"
#import "ACReminder.h"
#import "ACDueDate.h"

@interface ACTask : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *descriptionText;
@property (nonatomic) int textLineCount;
@property (nonatomic) BOOL completed;
@property (nonatomic) ACPriority *priority;
@property (nonatomic) ACCategory *category;
@property (nonatomic) ACReminder *reminderDate;
@property (nonatomic) ACDueDate *dueDate;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dateString;


-(ACTask *)initWithText:(NSString *)text description:(NSString *)text category:(ACCategory *)categoryName priority:(int)aPriorityNumber reminderDate:(NSDate *)aReminderDate dueDate:(NSDate *)aDueDate lineCount:(int)numberOfLines;

@end
