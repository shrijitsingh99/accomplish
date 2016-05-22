//
//  ACPushNotification.h
//  Accomplish
//
//  Created by Shrijit Singh on 13/04/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACTask.h"

@interface ACPushNotification : NSObject

+(void)scheduledPusNotificationForTask:(ACTask *)task on:(NSDate *)date;
-(void)cancelNotificationForTask:(ACTask *)task;

@end
