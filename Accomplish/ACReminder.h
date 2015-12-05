//
//  ACReminder.h
//  Accomplish
//
//  Created by Shrijit Singh on 10/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACReminder : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *dateString;
@property (nonatomic) BOOL isEnabled;

-(id)initWithReminderDate:(NSDate *)aDate;
+(NSDateFormatter *)dateFormat;

@end
