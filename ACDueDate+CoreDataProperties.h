//
//  ACDueDate+CoreDataProperties.h
//  Accomplish
//
//  Created by Shrijit Singh on 15/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ACDueDate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACDueDate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) ACTask *task;

@end

NS_ASSUME_NONNULL_END
