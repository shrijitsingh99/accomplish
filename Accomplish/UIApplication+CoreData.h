//
//  UIApplication+CoreData.h
//  Accomplish
//
//  Created by Shrijit Singh on 21/12/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (CoreData)

+(NSManagedObjectContext *)applicationManagedObjectContext;

@end
