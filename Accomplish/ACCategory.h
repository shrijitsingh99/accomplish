//
//  ACCategory.h
//  Accomplish
//
//  Created by Shrijit Singh on 04/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACCategory : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) UIColor *color;

-(id)initWithName:(NSString *)aName color:(UIColor *)aColor;

@end
