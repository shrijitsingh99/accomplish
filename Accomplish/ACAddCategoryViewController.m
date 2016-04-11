//
//  ACAddCategoryViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 03/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACAddCategoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+FlatColors.h"


@interface ACAddCategoryViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneBarButtonItem;
@property (weak, nonatomic) IBOutlet UITextView *categoryNameTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *colorPickerScrollView;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) UIColor *colorSelected;
@property (strong, nonatomic) UIButton *buttonSelected;

-(IBAction)didPresCancel:(UIButton *)sender;
-(IBAction)didPressAdd:(UIButton *)sender;

@end


@implementation ACAddCategoryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.categoryNameTextView.text = @"Category Name";
        self.categoryNameTextView.textColor = [UIColor flatSilverColor];
        self.categoryNameTextView.delegate = self;
    self.categoryNameTextView.textContainerInset = UIEdgeInsetsMake(12, 10, 0, 0);
    [self showColorPicker];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.categoryNameTextView.text = @"";
    self.categoryNameTextView.textColor = [UIColor whiteColor];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (self.categoryNameTextView.text.length == 0)
    {
        self.categoryNameTextView.textColor = [UIColor flatSilverColor];
        self.categoryNameTextView.text = @"Category Name";
        [self.categoryNameTextView resignFirstResponder];
    }
}

-(void)showColorPicker
{
    self.colors = [UIColor fetchFlatColors];
    self.colorSelected = self.colors[0];
    self.colorPickerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 145, 600, 40)];
    self.colorPickerScrollView.backgroundColor = [UIColor darkGrayColor];
    self.colorPickerScrollView.showsHorizontalScrollIndicator = NO;
    int x = 5;
    for (int count = 0; count < [self.colors count]; count++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 5, 30, 30)];
        [button addTarget:self action:@selector(didSelectColor:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = self.colors[count];
        button.layer.cornerRadius = 15;
        button.tag = count;
        [self.colorPickerScrollView addSubview:button];
        x = x + button.frame.size.width + 12;
    }
    self.colorPickerScrollView.contentSize = CGSizeMake(x + 8, 0);
    self.colorPickerScrollView.bounces = NO;
    [self.view addSubview:self.colorPickerScrollView];
}

-(void)didSelectColor:(UIButton *)sender
{
    [[self.buttonSelected viewWithTag:-1] removeFromSuperview];
    self.buttonSelected.selected = NO;
    if (sender.tag != -1)
    {
    self.colorSelected = self.colors[sender.tag];
    self.buttonSelected = sender;
    UIButton *selectedOverlay = [[UIButton alloc] initWithFrame:sender.bounds];
    sender.selected = YES;
    selectedOverlay.tag = -1;
    selectedOverlay.backgroundColor = [UIColor blackColor];
    selectedOverlay.layer.opacity = 0.7;
    selectedOverlay.layer.cornerRadius = 14.6;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((selectedOverlay.frame.size.width / 2) - 6), ((selectedOverlay.frame.size.height / 2) - 6), 12, 12)];
    imageView.image = [UIImage imageNamed:@"checkedIcon"];
    [selectedOverlay addTarget:self action:@selector(didSelectColor:) forControlEvents:UIControlEventTouchUpInside];
    [selectedOverlay addSubview:imageView];
    [sender addSubview:selectedOverlay];
    }
}

-(IBAction)didPresCancel:(UIButton *)sender
{
    [self.delegate categoryAddingCancelled];
}

-(IBAction)didPressAdd:(UIButton *)sender
{
    if (![self.categoryNameTextView.text isEqualToString:@""])
    {
        ACCategory *category = [ACCategory insertCategoryWithName:self.categoryNameTextView.text color:self.colorSelected serial:self.serialForCategoryToBeAdded];
        [self.delegate categoryAdded:category];
    }
    else
    {
        //Disable doneBarButtonItem
    }
}

@end
