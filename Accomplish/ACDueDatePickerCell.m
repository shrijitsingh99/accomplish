//
//  ACDueDatePickerCell.m
//  Accomplish
//
//  Created by Shrijit Singh on 03/12/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACDueDatePickerCell.h"
#import "UIDatePicker+HelperMethods.h"

@implementation ACDueDatePickerCell

//-(UIDatePicker *)datePicker
//{
//    return  [UIDatePicker sharedDatePicker];
//}

-(ACDueDatePickerCell *)setupCellWithDatePickerMode:(UIDatePickerMode)mode backgroundColor:(UIColor *)color
{
    self.datePicker.backgroundColor = color;
    self.datePicker.datePickerMode = mode;
    
    return self;
}

@end
