//
//  ACTableViewCell.h
//  Accomplish
//
//  Created by Shrijit Singh on 14/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"


@interface ACTableViewCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet UILabel *categoryColorLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskText;
@property (strong, nonatomic) IBOutlet UILabel *taskDate;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;

@end
