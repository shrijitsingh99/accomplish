//
//  ACSelectCategoryViewController.h
//  Accomplish
//
//  Created by Shrijit Singh on 03/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACAddCategoryViewController.h"
#import "MGSwipeTableCell.h"
#import "ACCategory.h"

@protocol ACSelectCategoryViewControllerDelegate <NSObject>

@required
-(void)selectedCategory:(ACCategory *)category categories:(NSArray *)categories;
-(void)didCancelSelectingCategory:(NSArray *)categories;

@end


@interface ACSelectCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ACAddCategoryViewControllerDelegate, MGSwipeTableCellDelegate>

@property (weak, nonatomic) id <ACSelectCategoryViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *categories;

@end
