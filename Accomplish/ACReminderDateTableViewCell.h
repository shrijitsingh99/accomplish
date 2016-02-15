//
//  ACReminderDateTableViewCell.h
//  Accomplish
//
//  Created by Shrijit Singh on 10/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"


@interface ACReminderDateTableViewCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet UILabel *reminderDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *isEnabledLabel;

-(void)setupCellWithReminderDate:(NSString *)aDateString forEnabledState:(BOOL)isEnabled;

@end
