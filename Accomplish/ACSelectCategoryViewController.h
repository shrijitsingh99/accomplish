//
//  ACSelectCategoryViewController.h
//  Accomplish
//
//  Created by Shrijit Singh on 03/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACAddCategoryViewController.h"
#import "ACCategory.h"

@protocol ACSelectCategoryViewControllerDelegate <NSObject>

@required

-(void)selectedCategory:(ACCategory *)category allCategories:(NSMutableArray *)allCategoriesArray;

@end

@interface ACSelectCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ACAddCategoryViewControllerDelegate>

@property (weak, nonatomic) id <ACSelectCategoryViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) ACCategory *category;

@end
