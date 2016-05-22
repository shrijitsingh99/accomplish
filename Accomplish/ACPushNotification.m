//
//  ACPushNotification.m
//  Accomplish
//
//  Created by Shrijit Singh on 13/04/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import "ACPushNotification.h"

@implementation ACPushNotification

+(void)scheduledPusNotificationForTask:(ACTask *)task on:(NSDate *)date
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *taskNotification = [[UILocalNotification alloc] init];
    taskNotification.fireDate = date;
    taskNotification.alertTitle = task.name;
    taskNotification.alertBody = task.details;
    taskNotification.alertAction = nil;
    taskNotification.timeZone = [NSTimeZone defaultTimeZone];
    taskNotification.soundName = UILocalNotificationDefaultSoundName;
    taskNotification.userInfo = [NSDictionary dictionaryWithObject:task.reminderDate forKey:[NSString stringWithFormat:@"%@", task.managedObjectContext]];
    [[UIApplication sharedApplication] scheduleLocalNotification:taskNotification];

}

-(void)cancelNotificationForTask:(ACTask *)task
{
    for (UILocalNotification *taskNotification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
        if (task.reminderDate == [taskNotification.userInfo objectForKey:[NSString stringWithFormat:@"%@", task.managedObjectContext]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:taskNotification];
        }
    }
    NSLog(@"Cancelled Notification");
}

@end
