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
#import "NSDateFormatter+HelperMethods.h"
#import "UIDatePicker+HelperMethods.h"
#import "ACPushNotification.h"


@interface ACAddTaskViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ACSelectCategoryViewControllerDelegate, MGSwipeTableCellDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ACTask *task;
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

-(IBAction)didPressCancelButton:(UIBarButtonItem *)sender;
-(IBAction)didPressAddButton:(UIBarButtonItem *)sender;
-(IBAction)didSelectPriority:(UISegmentedControl *)sender;

@end


@implementation ACAddTaskViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isInEditingMode == YES) {
        self.taskTextField.text = self.taskToEdit.name;
        self.taskDescriptionTextField.text = self.taskToEdit.details;
        self.selectedCategory = self.taskToEdit.category;
        self.selectedDueDate = self.taskToEdit.dueDate.date;
        self.selectedReminderDate = self.taskToEdit.reminderDate;
        self.selectedPriority = self.taskToEdit.priority;
    }
    
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
    
    
    NSDate *start = [NSDate date];
    [UIDatePicker sharedDatePicker];
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
    NSLog(@"Execution Time: %f", executionTime);
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
        return [categoryCell setupCellWithCategoryName:self.selectedCategory.name categoryImage:@"inboxIcon.png" categoryColor:self.selectedCategory.color];
    }
    if (indexPath.section == 1)
    {
        NSString *currentCell = [self.cellNames objectAtIndex:indexPath.row];
        if ([currentCell isEqualToString:@"dueDateCell"])
        {

            ACDueDateTableViewCell *dueDateCell = [tableView dequeueReusableCellWithIdentifier:@"dueDateCell" forIndexPath:indexPath];
            
            //Check and display current date if dueDatePickerIsEnabled
            if (self.selectedDueDate == nil && self.taskDueDateIsSet == YES)
            {
                [dueDateCell setupCellWithDueDate:[[NSDateFormatter sharedDateFormatter] stringFromDate:[NSDate date]] forEnabledState:self.taskDueDateIsSet];
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

            if (self.isDueDatePickerEnabled)
            {
                [datePickerCell.datePicker removeTarget:self action:@selector(reminderDateDidChange:) forControlEvents:UIControlEventValueChanged];
                [datePickerCell.datePicker addTarget:self action:@selector(dueDateDidChange:) forControlEvents:UIControlEventValueChanged];
                if (self.selectedDueDate == nil)
                {
                    datePickerCell.datePicker.date = [NSDate date];
                    self.selectedDueDate = [NSDate date];
                    self.dueDateString = [[NSDateFormatter sharedDateFormatter] stringFromDate:self.selectedDueDate];
                    
                }
                return [datePickerCell setupCellWithDatePickerMode:UIDatePickerModeDate backgroundColor:[UIColor flatConcreteColor]];

            
            }
            else if (self.isReminderDatePickerEnabled)
            {
                [datePickerCell.datePicker removeTarget:self action:@selector(dueDateDidChange:) forControlEvents:UIControlEventValueChanged];
                [datePickerCell.datePicker addTarget:self action:@selector(reminderDateDidChange:) forControlEvents:UIControlEventValueChanged];
                if (self.selectedReminderDate == nil)
                {
                    datePickerCell.datePicker.date = [NSDate date];
                    self.selectedReminderDate = [NSDate date];
                    self.reminderDateString = [[ACReminder dateFormat] stringFromDate:self.selectedDueDate];
                }
                return [datePickerCell setupCellWithDatePickerMode:UIDatePickerModeDateAndTime backgroundColor:[UIColor flatConcreteColor]];
            }
        }
        else if([currentCell isEqualToString:@"reminderCell"])
        {
            ACReminderDateTableViewCell *reminderDateCell = [tableView dequeueReusableCellWithIdentifier:@"reminderCell" forIndexPath:indexPath];
            
            //Check and display current date if dueDatePickerIsEnabled
            if (self.selectedReminderDate == nil && self.taskReminderIsSet == YES)
            {
                self.selectedReminderDate = [NSDate date];
                self.reminderDateString = [[ACReminder dateFormat] stringFromDate:self.selectedReminderDate];
                [reminderDateCell setupCellWithReminderDate:self.reminderDateString forEnabledState:self.taskReminderIsSet];
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
        return 165;
    }
    else if (self.isReminderDatePickerEnabled == YES && indexPath.section == 1 && indexPath.row == 2)
    {
        return 165;
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


#pragma Mark DatePickerCell Toolbar Methods

- (IBAction)didPressDoneAddingDueDate:(UIBarButtonItem *)sender
{
    if (self.isDueDatePickerEnabled)
    {
        self.isDueDatePickerEnabled = NO;
        self.taskDueDateIsSet = YES;
        [self performSelector:@selector(didFinishEditingDueDate:) withObject:nil];
    }
    else if (self.isReminderDatePickerEnabled)
    {
        self.isReminderDatePickerEnabled = NO;
        self.taskReminderIsSet = YES;
        [self performSelector:@selector(didFinishEditingReminderTime:) withObject:nil];
    }
}
- (IBAction)didPressRemoveDueDate:(UIBarButtonItem *)sender
{
    if (self.isDueDatePickerEnabled)
    {
        [self performSelector:@selector(didDeleteDueDate:) withObject:nil];
        self.isDueDatePickerEnabled = NO;
        [self performSelector:@selector(didFinishEditingDueDate:) withObject:nil];
    }
    else if (self.isReminderDatePickerEnabled)
    {
        [self performSelector:@selector(didDeleteReminderTime:) withObject:nil];
        self.isReminderDatePickerEnabled = NO;
        [self performSelector:@selector(didFinishEditingReminderTime:) withObject:nil];
    }
}

#pragma mark DatePicker Methods

-(void)dueDateDidChange:(UIDatePicker *)sender
{
    self.dueDateString = [[NSDateFormatter sharedDateFormatter] stringFromDate:sender.date];
    self.selectedDueDate = sender.date;
    NSLog(@"%@", self.dueDateString);
    [self.tableView reloadRowsAtIndexPaths:[self arrayForIndexPath:0 section:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(IBAction)didFinishEditingDueDate:(UIBarButtonItem *)sender
{
    [self.tableView deleteRowsAtIndexPaths:[self arrayForIndexPath:1 section:1] withRowAnimation:UITableViewRowAnimationFade];
}

-(IBAction)didDeleteDueDate:(id)sender
{
    self.dueDateString = @"";
    self.taskDueDateIsSet = NO;
    self.selectedDueDate = nil;
    self.isReminderDatePickerEnabled = NO;
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
    [self.tableView deleteRowsAtIndexPaths:[self arrayForIndexPath:2 section:1] withRowAnimation:UITableViewRowAnimationFade];
}

-(IBAction)didDeleteReminderTime:(UIBarButtonItem *)sender
{
    self.reminderDateString = @"";
    self.taskReminderIsSet = NO;
    self.selectedReminderDate = nil;
    [self.tableView reloadRowsAtIndexPaths:[self arrayForIndexPath:1 section:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark Helper Methods

-(NSArray *)arrayForIndexPath:(int)row section:(int)section
{
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:section]];;
}

-(ACDueDate *)dueDate
{   if (self.selectedDueDate)
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
    else
    {
        return nil;
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
    if (![self.taskTextField.text isEqualToString:@""])
    {
    self.task = [ACTask insertTaskWithName:self.taskTextField.text details:self.taskDescriptionTextField.text serial:nil priority:self.selectedPriority dueDate:[self dueDate] reminderDate:self.selectedReminderDate isCompleted:NO intoCategory:self.selectedCategory];

        if (self.task.reminderDate) {
            [ACPushNotification scheduledPusNotificationForTask:self.task on:self.task.reminderDate];
            NSLog(@"Registered Notification");
        }
        [self.delegate taskAdded];
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
    if (textView == self.taskTextField && [self.taskTextField.text isEqualToString:@"Task Name"])
    {
        self.taskTextField.text = @"";
        self.taskTextField.textColor = [UIColor whiteColor];
    }
    else if (textView == self.taskDescriptionTextField && [self.taskDescriptionTextField.text isEqualToString:@"Task Details"])
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
