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

@property (strong, nonatomic) IBOutlet UITextField *categoryNameTextField;

- (IBAction)yellowColorButton:(UIButton *)sender;
- (IBAction)orangeColorButton:(UIButton *)sender;
- (IBAction)redColorButton:(UIButton *)sender;
- (IBAction)purpleColorButton:(UIButton *)sender;
- (IBAction)greenColorButton:(UIButton *)sender;
- (IBAction)pinkColorButton:(UIButton *)sender;
- (IBAction)cyanColorButton:(UIButton *)sender;
- (IBAction)blueColorButton:(UIButton *)sender;


- (IBAction)didPresCancel:(UIButton *)sender;
- (IBAction)didPressAdd:(UIButton *)sender;

@end
