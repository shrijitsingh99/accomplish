//
//  ACReminder+CoreDataProperties.h
//  Accomplish
//
//  Created by Shrijit Singh on 23/05/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ACReminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACReminder (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *dateString;
@property (nullable, nonatomic, retain) NSNumber *repeat;
@property (nullable, nonatomic, retain) NSString *timeString;
@property (nullable, nonatomic, retain) ACTask *task;

@end

NS_ASSUME_NONNULL_END
