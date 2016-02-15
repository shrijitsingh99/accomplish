//
//  ACPriorityPickerTableViewCell.m
//  Accomplish
//
//  Created by Shrijit Singh on 09/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACPriorityPickerTableViewCell.h"


@implementation ACPriorityPickerTableViewCell

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:NO animated:animated];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setupCellWithPriority:(int)aPriorityNumber
{
	_priorityPicker.selectedSegmentIndex = aPriorityNumber;
}

@end
