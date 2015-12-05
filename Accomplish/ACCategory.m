//
//  ACCategory.m
//  Accomplish
//
//  Created by Shrijit Singh on 04/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACCategory.h"

@implementation ACCategory

-(id)initWithName:(NSString *)aName color:(UIColor *)aColor
{
    self = [super init];
    _name = aName;
    _color = aColor;
    
    return self;
}

@end
