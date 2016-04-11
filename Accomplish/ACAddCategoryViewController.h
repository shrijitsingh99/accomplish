//
//  ACAddCategoryViewController.h
//  Accomplish
//
//  Created by Shrijit Singh on 03/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACCategory.h"

@protocol ACAddCategoryViewControllerDelegate <NSObject>

@required
-(void)categoryAddingCancelled;
-(void)categoryAdded:(ACCategory *)category;

@end


@interface ACAddCategoryViewController : UIViewController

@property (weak, nonatomic) id <ACAddCategoryViewControllerDelegate> delegate;

@property (nonatomic) int serialForCategoryToBeAdded;

@end
