//
//  ACAddCategoryViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 03/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACAddCategoryViewController.h"

@interface ACAddCategoryViewController ()

@property (strong, nonatomic) UIColor *colorSelected;
@property (strong, nonatomic) NSMutableArray *buttonSelectedArray;

@end

@implementation ACAddCategoryViewController

-(id)colorSelected
{
    if (!_colorSelected) _colorSelected = [[UIColor alloc] init];
    return _colorSelected;
}

-(id)buttonSelectedArray
{
    if (!_buttonSelectedArray) _buttonSelectedArray = [[NSMutableArray alloc] init];
    return _buttonSelectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc] init];
    [self.buttonSelectedArray addObject:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)yellowColorButton:(UIButton *)sender
{
    self.colorSelected =[UIColor yellowColor];
    [self selectButton:sender];
}

- (IBAction)orangeColorButton:(UIButton *)sender
{
    self.colorSelected =[UIColor orangeColor];
    [self selectButton:sender];
}

- (IBAction)redColorButton:(UIButton *)sender
{
    self.colorSelected =[UIColor redColor];
    [self selectButton:sender];
}

- (IBAction)purpleColorButton:(UIButton *)sender
{
    self.colorSelected =[UIColor purpleColor];
    [self selectButton:sender];
}

- (IBAction)greenColorButton:(UIButton *)sender
{
    self.colorSelected =[UIColor greenColor];
    [self selectButton:sender];
}

- (IBAction)pinkColorButton:(UIButton *)sender
{
    self.colorSelected =[UIColor blackColor];
    [self selectButton:sender];
}

- (IBAction)cyanColorButton:(UIButton *)sender
{
    self.colorSelected =[UIColor cyanColor];
    [self selectButton:sender];
}

- (IBAction)blueColorButton:(UIButton *)sender
{
    self.colorSelected =[UIColor blueColor];
    [self selectButton:sender];
}

-(void)selectButton:(UIButton *)button
{
    UIButton *buttonPreviouslySelected = [self.buttonSelectedArray objectAtIndex:0];
    [self.buttonSelectedArray removeAllObjects];
    [self.buttonSelectedArray addObject:button];
    button.selected = YES;
    buttonPreviouslySelected.selected = NO;
}

- (IBAction)didPresCancel:(UIButton *)sender {
    [self.delegate categoryAddingCancelled];
}

- (IBAction)didPressAdd:(UIButton *)sender {
    ACCategory *category = [[ACCategory alloc] initWithName:self.categoryNameTextField.text color:self.colorSelected];
    [self.delegate categoryAdded:category];
    
}


@end
