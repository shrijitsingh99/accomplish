//
//  ACCategory.m
//  Accomplish
//
//  Created by Shrijit Singh on 21/12/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACCategory.h"
#import "UIApplication+CoreData.h"

@implementation ACCategory

+(NSEntityDescription *)entity {
	return [NSEntityDescription entityForName:@"Category" inManagedObjectContext:[UIApplication applicationManagedObjectContext]];
}


+(ACCategory *)insertCategoryWithName:(NSString *)name color:(UIColor *)color serial:(int)serial {

	ACCategory *coreDataCategory = [SSCoreData insertNewObjectForEntityForName:@"Category"];
	coreDataCategory.name = name;
	coreDataCategory.color = color;
	coreDataCategory.serial = [NSNumber numberWithInt:serial];
	[ACCategory saveCategories];
	return coreDataCategory;
}

+(void)saveCategories {
	NSError *error = nil;
	if (![[UIApplication applicationManagedObjectContext] save:&error]) {
		NSLog(@"Error occured while saving category");
	}

}

+(NSArray *)fetchCategories {
	NSArray *categories = [SSCoreData fetchObjectsForEntityForName:@"Category" withSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"serial"
	                                                                                                  ascending:YES]]];
//	NSLog(@"Fetched Categories:%@",categories);

	return categories;
}
-(void)removeCategory {
	[ACCategory removeCategories:@[self]];
}

+(void)removeCategories:(NSArray *)categories {
	[SSCoreData removeObjects:categories];
	[ACCategory saveCategories];

}

+(void)changeCategorySequenceforCategories:(NSArray *)categories {
    int serial = 1;
    for (ACCategory *category in categories)
    {
        category.serial = [NSNumber numberWithInt:serial];
        serial++;
        
    }

	[ACCategory saveCategories];
}

@end
