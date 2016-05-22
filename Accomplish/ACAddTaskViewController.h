//
//  ACAddTaskViewController.h
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACSelectCategoryViewController.h"
#import "ACCategory.h"
#import "ACPriorityPickerTableViewCell.h"
#import "ACReminderDateTableViewCell.h"
#import "ACCategoryTableViewCell.h"
#import "ACDueDatePickerCell.h"
#import "ACDueDateTableViewCell.h"
#import "ACDueDate.h"

@protocol ACAddTaskViewControllerDelegate <NSObject>

@required
-(void)taskAddingCancelled;
-(void)taskAdded:(ACTask *)task isEditing:(BOOL)editing categoriesList:(NSMutableArray *)categories dates:(NSArray *)dates;

@end


@interface ACAddTaskViewController : UIViewController

@property (weak, nonatomic) id <ACAddTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) ACTask *taskToEdit;
@property (nonatomic) BOOL isInEditingMode;

@end
