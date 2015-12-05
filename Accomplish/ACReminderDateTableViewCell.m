//
//  ACReminderDateTableViewCell.m
//  Accomplish
//
//  Created by Shrijit Singh on 10/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACReminderDateTableViewCell.h"

@implementation ACReminderDateTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

}

-(void)setupCellWithReminderDate:(NSString *)aDateString forEnabledState:(BOOL)isEnabled;
{
    _reminderDateLabel.text = aDateString;
    if (isEnabled) {
        _isEnabledLabel.backgroundColor = [UIColor whiteColor];
        
    }
    else{
        _isEnabledLabel.backgroundColor = [UIColor clearColor];
        
    }
}

@end
