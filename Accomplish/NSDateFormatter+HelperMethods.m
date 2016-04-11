//
//  NSDateFormatter+HelperMethods.m
//  Accomplish
//
//  Created by Shrijit Singh on 16/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import "NSDateFormatter+HelperMethods.h"

@implementation NSDateFormatter (HelperMethods)

+(NSDateFormatter *)sharedDateFormatter {
    static NSDateFormatter *_sharedInstance = nil;

    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.dateStyle = NSDateIntervalFormatterMediumStyle;
    });
    
    return _sharedInstance;
}

@end
