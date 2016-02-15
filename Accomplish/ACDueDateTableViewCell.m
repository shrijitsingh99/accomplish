//
//  ACDueDateTableViewCell.m
//  Accomplish
//
//  Created by Shrijit Singh on 18/11/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACDueDateTableViewCell.h"


@implementation ACDueDateTableViewCell

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:NO animated:animated];
}

-(void)setupCellWithDueDate:(NSString *)dateString forEnabledState:(BOOL)isEnabled
{
	_dueDateLabel.text = dateString;
	if (isEnabled)
    {
		_isEnabledLabel.backgroundColor = [UIColor whiteColor];
	}
	else
    {
		_isEnabledLabel.backgroundColor = [UIColor clearColor];
	}
}

@end
