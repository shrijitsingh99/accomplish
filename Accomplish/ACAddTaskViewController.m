//
//  ACAddTaskViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACAddTaskViewController.h"
#import "ACSelectCategoryViewController.h"
#import "ACViewController.h"
#import "MGSwipeButton.h"
#import "UIColor+FlatColors.h"
#import "MBAutoGrowingTextView.h"
#import "ACReminder.h"


@interface ACAddTaskViewController () <UITextViewDelegate>

@property (strong, nonatomic) ACCategory *selectedCategory;

@property (strong, nonatomic) IBOutlet MBAutoGrowingTextView *taskTextField;
@property (strong, nonatomic) IBOutlet MBAutoGrowingTextView *taskDescriptionTextField;

@property (strong, nonatomic) NSDate *selectedDueDate;
@property (strong, nonatomic) NSString *dueDateString;

@property (strong, nonatomic) NSDate *selectedReminderDate;
@property (strong, nonatomic) NSString *reminderDateString;

@property (strong, nonatomic) UISegmentedControl *priorityPicker;
@property (nonatomic) int selectedPriority;

@property (nonatomic) int numberOfLines;

@property (nonatomic) BOOL taskDueDateIsSet;
@property (nonatomic) BOOL taskReminderIsSet;

@property (strong, nonatomic) NSMutableArray *cellNames;

@property (nonatomic) BOOL isDueDatePickerEnabled;
@property (nonatomic) BOOL isReminderDatePickerEnabled;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation ACAddTaskViewController

-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return  _dateFormatter;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.taskTextField.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO; //Fix for textfield not starting from top
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.tableView.estimatedRowHeight = 44;
    
    self.selectedCategory = self.categories[1];

    self.taskTextField.text = @"Task Name";
    self.taskDescriptionTextField.text = @"Task Details";
    self.taskTextField.textColor = [UIColor flatSilverColor];
    self.taskDescriptionTextField.textColor = [UIColor flatSilverColor];
    self.taskTextField.delegate = self;
    self.taskDescriptionTextField.delegate = self;

    
    
}


#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if(section ==1)
    {
        [self.cellNames removeAllObjects];
        [self.cellNames addObjectsFromArray:@[@"dueDateCell", @"reminderCell"]];
        if (self.isDueDatePickerEnabled)
        {
            [self.cellNames removeAllObjects];
            [self.cellNames addObjectsFromArray:@[@"dueDateCell", @"datePickerCell", @"reminderCell"]];
            return 3;
        }
        else if (self.isReminderDatePickerEnabled)
        {
            [self.cellNames removeAllObjects];
            [self.cellNames addObjectsFromArray:@[@"dueDateCell", @"reminderCell", @"datePickerCell"]];
            return 3;
        }
        return 2;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0 && indexPath.section == 0)
    {
        ACCategoryTableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        self.selectedCategory.color = [UIColor greenColor];
        [categoryCell setupCellWithCategoryName:self.selectedCategory.name categoryImage:@"inboxIcon.png" categoryColor:self.selectedCategory.color];
        return categoryCell;
    }
    if (indexPath.section == 1)
    {
        NSString *currentCell = [self.cellNames objectAtIndex:indexPath.row];
        if ([currentCell isEqualToString:@"dueDateCell"])
        {

            ACDueDateTableViewCell *dueDateCell = [tableView dequeueReusableCellWithIdentifier:@"dueDateCell" forIndexPath:indexPath];
            
            //Check and display current date if dueDatePickerIsEnabled
            if (self.selectedDueDate == NO && self.isDueDatePickerEnabled == YES)
            {
                [dueDateCell setupCellWithDueDate:[self.dateFormatter stringFromDate:[NSDate date]] forEnabledState:self.taskDueDateIsSet];
            }
            else
            {
                [dueDateCell setupCellWithDueDate:self.dueDateString forEnabledState:self.taskDueDateIsSet];
            }
            dueDateCell.delegate = self;
            return dueDateCell;
        }
        else if ([currentCell isEqualToString:@"datePickerCell"])
        {
            ACDueDatePickerCell *datePickerCell = [tableView dequeueReusableCellWithIdentifier:@"datePickerCell" forIndexPath:indexPath];
            datePickerCell.datePicker.backgroundColor = [UIColor greenColor];
            if (self.isDueDatePickerEnabled)
            {
                datePickerCell.datePicker.datePickerMode = UIDatePickerModeDate;
                [datePickerCell.datePicker removeTarget:self action:@selector(reminderDateDidChange:) forControlEvents:UIControlEventValueChanged];
                [datePickerCell.datePicker addTarget:self action:@selector(dueDateDidChange:) forControlEvents:UIControlEventValueChanged];
                if (self.selectedDueDate == nil)
                {
                    datePickerCell.datePicker.date = [NSDate date];
                    self.selectedDueDate = [NSDate date];
                    self.dueDateString = [self.dateFormatter stringFromDate:self.selectedDueDate];
                    
                }
            }
            else if (self.isReminderDatePickerEnabled)
            {
                datePickerCell.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                [datePickerCell.datePicker removeTarget:self action:@selector(dueDateDidChange:) forControlEvents:UIControlEventValueChanged];
                [datePickerCell.datePicker addTarget:self action:@selector(reminderDateDidChange:) forControlEvents:UIControlEventValueChanged];
                if (self.selectedReminderDate == nil)
                {
                    datePickerCell.datePicker.date = [NSDate date];
                    self.selectedReminderDate = [NSDate date];
                    self.reminderDateString = [[ACReminder dateFormat] stringFromDate:self.selectedDueDate];
                }
            }
            return datePickerCell;
        }
        else if([currentCell isEqualToString:@"reminderCell"])
        {
            ACReminderDateTableViewCell *reminderDateCell = [tableView dequeueReusableCellWithIdentifier:@"reminderCell" forIndexPath:indexPath];
            
            //Check and display current date if dueDatePickerIsEnabled
            if (self.selectedReminderDate == NO && self.isReminderDatePickerEnabled == YES)
            {
                [reminderDateCell setupCellWithReminderDate:[[ACReminder dateFormat] stringFromDate:[NSDate date]] forEnabledState:self.taskReminderIsSet];
            }
            else
            {
                [reminderDateCell setupCellWithReminderDate:self.reminderDateString forEnabledState:self.taskReminderIsSet];
            }
            reminderDateCell.delegate = self;
            return reminderDateCell;
        }
    }
    else if (indexPath.row==0 && indexPath.section == 2)
    {
        ACPriorityPickerTableViewCell *priorityCell = [tableView dequeueReusableCellWithIdentifier:@"priorityCell" forIndexPath:indexPath];
        [priorityCell setupCellWithPriority:self.selectedPriority];
        return priorityCell;
    }
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDueDatePickerEnabled == YES && indexPath.section == 1 && indexPath.row == 1)
    {
        return 150;
    }
    else if (self.isReminderDatePickerEnabled == YES && indexPath.section == 1 && indexPath.row == 2)
    {
        return 150;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0 && indexPath.section ==0)
    {
        [self performSegueWithIdentifier:@"pushToAddCategory" sender:tableView];
    }
    if ([[[self.tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"dueDateCell"])
    {
        if (self.isDueDatePickerEnabled)
        {
            self.isDueDatePickerEnabled = NO;
            [self performSelector:@selector(didFinishEditingDueDate:) withObject:nil];
        }
        else if (!self.isDueDatePickerEnabled)
        {
            self.isDueDatePickerEnabled = YES;
            self.isReminderDatePickerEnabled = NO;
            self.taskDueDateIsSet = YES;
            
        }
        [self.tableView reloadData];
    }
    
    else if([[[self.tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"reminderCell"])
    {
        if (self.isReminderDatePickerEnabled)
        {
            self.isReminderDatePickerEnabled = NO;
            [self performSelector:@selector(didFinishEditingReminderTime:) withObject:nil];
        }
        else if (!self.isReminderDatePickerEnabled)
        {
            self.isReminderDatePickerEnabled = YES;
            self.isDueDatePickerEnabled = NO;
            self.taskReminderIsSet = YES;
            
        }
        [self.tableView reloadData];
    }
    
}


#pragma mark DatePicker Methods

-(void)dueDateDidChange:(UIDatePicker *)sender
{
    self.dueDateString = [self.dateFormatter stringFromDate:sender.date];
    self.selectedDueDate = sender.date;
    [self.tableView reloadRowsAtIndexPaths:[self arrayForIndexPath:0 section:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(IBAction)didFinishEditingDueDate:(UIBarButtonItem *)sender
{
    self.taskDueDateIsSet = YES;
    [self.tableView reloadData];
}

-(IBAction)didDeleteDueDate:(id)sender
{
    self.dueDateString = @"";
    self.taskDueDateIsSet = NO;
    self.selectedDueDate = nil;
    [self.tableView reloadRowsAtIndexPaths:[self arrayForIndexPath:0 section:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark TimePicker Methods

-(void)reminderDateDidChange:(UIDatePicker *)sender
{
    self.reminderDateString = [[ACReminder dateFormat] stringFromDate:sender.date];
    self.selectedReminderDate = sender.date;
    [self.tableView reloadRowsAtIndexPaths:[self arrayForIndexPath:1 section:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(IBAction)didFinishEditingReminderTime:(UIBarButtonItem *)sender
{
    self.taskReminderIsSet = YES;
    [self.tableView reloadData];
}

-(IBAction)didDeleteReminderTime:(UIBarButtonItem *)sender
{
    
    self.reminderDateString = @"";
    self.taskReminderIsSet = NO;
    self.selectedReminderDate = nil;
    [self.tableView reloadRowsAtIndexPaths:[self arrayForIndexPath:1 section:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark SwipeCell Methods

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction
{
    if (self.isDueDatePickerEnabled)
    {
        return NO;
    }
    return YES;
}

-(NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionClipCenter;
    swipeSettings.keepButtonsSwiped = YES;
    expansionSettings.buttonIndex = 0;
    expansionSettings.threshold = 1.5;
    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
    expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunctionCubicOut;
    expansionSettings.fillOnTrigger = NO;
    UIColor *redColor = [UIColor colorWithRed:1.0 green:(59 / 255.0) blue:(50 / 255.0) alpha:1.0];
    if (direction == MGSwipeDirectionRightToLeft)
    {
        MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:redColor padding:15 callback:^BOOL (MGSwipeTableCell *sender)
        {
            if ([self.tableView indexPathForCell:cell].row == 0 && [self.tableView indexPathForCell:cell].section == 1)
            {
                [self performSelector:@selector(didDeleteDueDate:) withObject:nil];
            }
            if ([self.tableView indexPathForCell:cell].row == 1 && [self.tableView indexPathForCell:cell].section == 1)
            {
                [self performSelector:@selector(didDeleteReminderTime:) withObject:nil];
            }
            return YES;
        }];
        return @[deleteButton];
    }
    return nil;
}


#pragma mark Helper Methods

-(NSArray *)arrayForIndexPath:(int)row section:(int)section
{
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:section]];;
}

-(ACDueDate *)dueDate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date CONTAINS %@", self.dueDateString];
    NSArray *date = [self.dates filteredArrayUsingPredicate:predicate];
    if ([date count] == 1)
    {
        return date[0];
    }
    else
    {
        ACDueDate *dueDate = [ACDueDate insertDueDateWithDate:self.selectedDueDate];
        [self.dates addObject:dueDate];
        return dueDate;
    }
}


#pragma mark ACSelectCategoryViewControllerDelegate

-(void)selectedCategory:(ACCategory *)category categories:(NSArray *)categories
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.selectedCategory = category;
    [self.tableView reloadRowsAtIndexPaths:[self arrayForIndexPath:0 section:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (([self.categories count] - 1) != [categories count])
    {
        [self.categories removeObjectsInRange:NSMakeRange(1, ([self.categories count] - 1))];
        [self.categories addObjectsFromArray:categories];
    }
}

-(void)didCancelSelectingCategory:(NSArray *)categories
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (([self.categories count] - 1) != [categories count])
    {
        [self.categories removeObjectsInRange:NSMakeRange(1, ([self.categories count] - 1))];
        [self.categories addObjectsFromArray:categories];
    }
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToAddCategory"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        ACSelectCategoryViewController *selectCategoryViewController = (ACSelectCategoryViewController *)navigationController.topViewController;
        selectCategoryViewController.categories = [self.categories mutableCopy];
        [selectCategoryViewController.categories removeObjectAtIndex:0];
        selectCategoryViewController.delegate = self;
    }
}


#pragma mark UIBarButton Actions

-(IBAction)didPressCancelButton:(UIBarButtonItem *)sender
{
    [self.delegate taskAddingCancelled];
}

-(IBAction)didPressAddButton:(UIBarButtonItem *)sender
{
    self.task = [ACTask insertTaskWithName:self.taskTextField.text details:self.taskDescriptionTextField.text serial:nil priority:self.selectedPriority dueDate:[self dueDate] reminderDate:self.selectedReminderDate isCompleted:NO intoCategory:self.selectedCategory];
    [ACTask saveTasks];
    if (![self.taskTextField.text isEqualToString:@""])
    {
        [self.delegate taskAdded:self.task isEditing:self.isInEditingMode == FALSE categoriesList:self.categories dates:self.dates];
    }
    else
    {
        [self.delegate taskAddingCancelled];
    }
}


#pragma mark Switch and Segment Methods

-(IBAction)didSelectPriority:(UISegmentedControl *)sender
{
    self.selectedPriority = (int) sender.selectedSegmentIndex;
}


#pragma mark TextView Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == self.taskTextField)
    {
        self.taskTextField.text = @"";
        self.taskTextField.textColor = [UIColor whiteColor];
    }
    else if (textView == self.taskDescriptionTextField)
    {
        self.taskDescriptionTextField.text = @"";
        self.taskDescriptionTextField.textColor = [UIColor whiteColor];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.taskTextField.text.length == 0)
    {
        self.taskTextField.textColor = [UIColor flatSilverColor];
        self.taskTextField.text = @"Task Name";
        [self.taskTextField resignFirstResponder];
    }
    else if (self.taskDescriptionTextField.text.length == 0)
    {
        self.taskDescriptionTextField.textColor = [UIColor flatSilverColor];
        self.taskDescriptionTextField.text = @"Task Details";
        [self.taskDescriptionTextField resignFirstResponder];
    }
    return YES;
    
}


#pragma Lazy Initialization

-(NSMutableArray *)cellNames
{
    if (!_cellNames) _cellNames = [[NSMutableArray alloc] init];
    return _cellNames;
}

@end
