//
//  SSCoreData.h
//  Accomplish
//
//  Created by Shrijit Singh on 05/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SSCoreData : NSObject

+(NSManagedObjectContext *)managedObjectContext;
+(NSEntityDescription *)entityForName:(NSString *)entityName;
+(void)saveManagedObjectContext;
+(id)insertNewObjectForEntityForName:(NSString *)entityName;
+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors batchSize:(int)batchSize fetchOffset:(int)offset;
+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName withSortDescriptors:(NSArray *)sortDescriptors;
+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName;
+(void)removeObjects:(NSArray *)objects;
@end
