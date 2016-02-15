//
//  ACCategory+CoreDataProperties.h
//  Accomplish
//
//  Created by Shrijit Singh on 15/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ACCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) id color;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *serial;
@property (nullable, nonatomic, retain) ACTask *task;

@end

NS_ASSUME_NONNULL_END
