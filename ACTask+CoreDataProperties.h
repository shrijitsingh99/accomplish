//
//  ACTask+CoreDataProperties.h
//  Accomplish
//
//  Created by Shrijit Singh on 14/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ACTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACTask (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *completed;
@property (nullable, nonatomic, retain) NSString *details;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *priority;
@property (nullable, nonatomic, retain) NSDate *reminderDate;
@property (nullable, nonatomic, retain) NSNumber *serial;
@property (nullable, nonatomic, retain) ACCategory *category;
@property (nullable, nonatomic, retain) ACDueDate *dueDate;

@end

NS_ASSUME_NONNULL_END
