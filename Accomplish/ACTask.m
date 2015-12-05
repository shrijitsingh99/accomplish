//
//  ACTask.m
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACTask.h"

@implementation ACTask

-(ACTask *)initWithText:(NSString *)text description:(NSString *)descriptionText category:(ACCategory *)categoryName priority:(int)aPriorityNumber reminderDate:(NSDate *)aReminderDate dueDate:(NSDate *)aDueDate lineCount:(int)numberOfLines
{
    self = [super init];
    
    if (self) {
        
        _text = text;
        
        _descriptionText = descriptionText;
        
        _category = categoryName;
        
        _priority = [[ACPriority alloc] init];
        _priority.number = aPriorityNumber;
        
        _reminderDate = [[ACReminder alloc] initWithReminderDate:aReminderDate];

        _dueDate = [[ACDueDate alloc] initWithDueDate:aDueDate];
        
        _textLineCount = numberOfLines;
        
        return self;
    }
    
    NSLog(@"Initialization of task failed");
    
    return nil;
}

@end
