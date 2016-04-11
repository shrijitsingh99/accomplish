//
//  ACSelectCategoryTableViewCell.h
//  Accomplish
//
//  Created by Shrijit Singh on 11/04/16.
//  Copyright © 2016 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface ACSelectCategoryTableViewCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryColorLabel;

@end
