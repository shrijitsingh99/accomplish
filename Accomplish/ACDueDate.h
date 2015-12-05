//
//  ACDueDate.h
//  Accomplish
//
//  Created by Shrijit Singh on 21/11/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACDueDate : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic) BOOL isEnabled;

-(id)initWithDueDate:(NSDate *)aDate;
+(NSDateFormatter *)dateFormat;

@end
