//
//  ACSelectCategoryToSortViewController.h
//  Accomplish
//
//  Created by Shrijit Singh on 12/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACCategory.h"

@protocol ACSelectCategoryToSortViewControllerDelegate <NSObject>

@required

-(void)didCancelSelectingCategory;
-(void)didSelectCategory:(ACCategory *)category;

@end

@interface ACSelectCategoryToSortViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <ACSelectCategoryToSortViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *categoryToSelectArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)didPressCancel:(UIBarButtonItem *)sender;
- (IBAction)didPressEdit:(UIBarButtonItem *)sender;

@end
