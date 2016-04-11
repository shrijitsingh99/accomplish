//
//  ACCategory.h
//  Accomplish
//
//  Created by Shrijit Singh on 21/12/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSCoreData.h"
#import "ACTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACCategory : NSManagedObject

+(NSEntityDescription *)entity;
+(ACCategory *)insertCategoryWithName:(NSString *)name color:(UIColor *)color serial:(int)serial;
+(NSArray *)fetchCategories;
+(NSArray *)changeCategorySequenceforCategories:(NSArray *)categories;
+(void)saveCategories;
+(void)removeCategories:(NSArray *)categories;
-(void)removeCategory;
+(void)setupCategories;
+(NSMutableArray *)arrangeTasks:(NSMutableArray *)tasks byCategory:(ACCategory *)category;

@end

NS_ASSUME_NONNULL_END

#import "ACCategory+CoreDataProperties.h"
