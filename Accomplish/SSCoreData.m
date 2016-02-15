//
//  SSCoreData.m
//  Accomplish
//
//  Created by Shrijit Singh on 05/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import "SSCoreData.h"
#import "AppDelegate.h"

@implementation SSCoreData

+(NSManagedObjectContext *)managedObjectContext {
	return [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

+(NSEntityDescription *)entityForName:(NSString *)entityName {
	return [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
}

+(void)saveManagedObjectContext {
	NSError *error = nil;
	if ([[self managedObjectContext] save:&error]) {
		NSLog(@"An error occured while saving ManagedObjectContext");
		NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
		abort();
	}
}

+(id)insertNewObjectForEntityForName:(NSString *)entityName {
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[self managedObjectContext]];
}

+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors batchSize:(int)batchSize fetchOffset:(int)offset {
    if(entityName) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        if (predicate) {
            fetchRequest.predicate = predicate;
        }
        if (sortDescriptors) {
            fetchRequest.sortDescriptors = sortDescriptors;
        }
        if (batchSize) {
            fetchRequest.fetchLimit = batchSize;
        }
        if (offset) {
            fetchRequest.fetchOffset = offset;
        }
        [fetchRequest setReturnsObjectsAsFaults:NO];
        NSError *error = nil;
        NSLog(@"Fetching Objects for Enitiy:%@", entityName);
        return [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    }
    return nil;
}

+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    return [SSCoreData fetchObjectsForEntityForName:entityName withPredicate:predicate sortDescriptors:sortDescriptors batchSize:nil fetchOffset:nil];
}


+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
	return [self fetchObjectsForEntityForName:entityName withPredicate:predicate sortDescriptors:nil];
}

+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName withSortDescriptors:(NSArray *)sortDescriptors {
	return [self fetchObjectsForEntityForName:entityName withPredicate:nil sortDescriptors:sortDescriptors];
}

+(NSArray *)fetchObjectsForEntityForName:(NSString *)entityName {
	return [self fetchObjectsForEntityForName:entityName withPredicate:nil];
}

+(void)removeObjects:(NSArray *)objects {
	for (id object in objects) {
		[[self managedObjectContext] deleteObject:object];
	}
}

@end
