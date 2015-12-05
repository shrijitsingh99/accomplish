//
//  ACAddTaskViewController.h
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACTask.h"
#import "ACSelectCategoryViewController.h"
#import "ACCategory.h"
#import "ACPriorityPickerTableViewCell.h"
#import "ACPriority.h"
#import "ACReminderDateTableViewCell.h"
#import "ACCategoryTableViewCell.h"
#import "ACDueDatePickerCell.h"
#import "ACDueDateTableViewCell.h"

@protocol ACAddTaskViewControllerDelegate <NSObject, MGSwipeTableCellDelegate>

@required

-(void)taskAddingCancelled;
-(void)taskAdded:(ACTask *)task isEditing:(BOOL)editing categoriesList:(NSMutableArray *)allCategoriesList;

@end

@interface ACAddTaskViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ACSelectCategoryViewControllerDelegate>

@property (weak, nonatomic) id <ACAddTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ACTask *task;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic)ACTask *taskToEdit;
@property (nonatomic) BOOL isInEditingMode;

- (IBAction)didPressCancelButton:(UIBarButtonItem *)sender;
- (IBAction)didPressAddButton:(UIBarButtonItem *)sender;
- (IBAction)didSwipeDown:(UISwipeGestureRecognizer *)sender;
- (IBAction)didSelectPriority:(UISegmentedControl *)sender;

@end
