//
//  ACViewController.h
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACAddTaskViewController.h"
#import "ACCategory.h"

@interface ACViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ACAddTaskViewControllerDelegate, ACSelectCategoryViewControllerDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSMutableArray *visibleTasks;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) ACCategory *category;
@property (strong, nonatomic) IBOutlet UIButton *selectCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *addNewButton;
@property (strong, nonatomic) IBOutlet UITextField *addTaskTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *menuBarScrollView;

@end
