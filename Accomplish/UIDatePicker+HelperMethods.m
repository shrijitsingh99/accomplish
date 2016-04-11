//
//  UIDatePicker+HelperMethods.m
//  Accomplish
//
//  Created by Shrijit Singh on 16/02/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import "UIDatePicker+HelperMethods.h"

@implementation UIDatePicker (HelperMethods)

+(UIDatePicker *)sharedDatePicker {
    static UIDatePicker *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


@end
