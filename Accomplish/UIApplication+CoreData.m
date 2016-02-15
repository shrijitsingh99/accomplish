//
//  UIApplication+CoreData.m
//  Accomplish
//
//  Created by Shrijit Singh on 21/12/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "UIApplication+CoreData.h"

@implementation UIApplication (CoreData)

+(NSManagedObjectContext *)applicationManagedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

@end
