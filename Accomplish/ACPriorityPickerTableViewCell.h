//
//  ACPriorityPickerTableViewCell.h
//  Accomplish
//
//  Created by Shrijit Singh on 09/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPriorityPickerTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong, nonatomic) IBOutlet UISegmentedControl *priorityPicker;

-(void)setupCellWithPriority:(int)aPriorityNumber;

@end
