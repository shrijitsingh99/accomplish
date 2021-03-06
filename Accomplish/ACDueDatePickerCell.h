//
//  ACDueDatePickerCell.h
//  Accomplish
//
//  Created by Shrijit Singh on 03/12/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ACDueDatePickerCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *datePickerToolbar;

-(ACDueDatePickerCell *)setupCellWithDatePickerMode:(UIDatePickerMode)mode backgroundColor:(UIColor *)color;

@end
