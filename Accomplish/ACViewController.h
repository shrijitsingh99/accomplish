//
//  ACViewController.h
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACTask.h"
#import "ACAddTaskViewController.h"
#import "ACCategory.h"
#import "ACSelectCategoryToSortViewController.h"
#import "ACTableViewCell.h"


@interface ACViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ACAddTaskViewControllerDelegate, ACSelectCategoryToSortViewControllerDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *taskArray;
@property (strong, nonatomic) NSMutableArray *allTasksList;
@property (strong, nonatomic) NSMutableArray *allCategoriesList;
@property (strong, nonatomic) NSMutableArray *currentCategoriesList;
@property (strong, nonatomic) NSMutableDictionary *categoryDictionary;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) ACCategory *category;
@property (strong, nonatomic) IBOutlet UIButton *selectCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *addNewButton;
@property (strong, nonatomic) IBOutlet UITextField *addTaskTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *menuBarScrollView;

- (IBAction)addNewTask:(UIButton *)sender;

@end
