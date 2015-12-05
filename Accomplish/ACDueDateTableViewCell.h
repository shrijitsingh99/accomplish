//
//  ACDueDateTableViewCell.h
//  Accomplish
//
//  Created by Shrijit Singh on 18/11/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface ACDueDateTableViewCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *isEnabledLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

-(void)setupCellWithDueDate:(NSString *)aDateString forEnabledState:(BOOL)isEnabled;

@end
