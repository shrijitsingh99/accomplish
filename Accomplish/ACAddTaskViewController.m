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

@interface ACAddTaskViewController () <UITextViewDelegate>

@property (strong, nonatomic) ACCategory *selectedCategory;

@property (strong, nonatomic) IBOutlet UITextView *taskTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskDescriptionTextField;

@property (strong, nonatomic) NSDate *selectedDueDate;
@property (strong, nonatomic) NSString *dueDateString;

@property (strong, nonatomic) NSDate *selectedReminderDate;
@property (strong, nonatomic) NSString *reminderDateString;

@property (strong, nonatomic) UISegmentedControl *priorityPicker;
@property (nonatomic) int selectedPriority;

@property (nonatomic) int numberOfLines;

@property (nonatomic) BOOL taskDueDateIsSet;
@property (nonatomic) BOOL taskReminderIsSet;

@property (strong, nonatomic) NSMutableArray *arrayOfCellNames;

@property (nonatomic) BOOL isDueDatePickerEnabled;
@property (nonatomic) BOOL isReminderDatePickerEnabled;

@end

@implementation ACAddTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.arrayOfCellNames = [NSMutableArray array];
    self.taskTextField.delegate = self;
    self.selectedReminderDate = [[NSDate alloc] init];
    
    self.numberOfLines = 1;
    
    self.selectedDueDate = [[NSDate alloc] init];
    self.selectedDueDate = nil;
    
    self.selectedReminderDate = [[NSDate alloc] init];
    self.selectedReminderDate = nil;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionFooterHeight = 0.0f;
    
    
    self.selectedCategory = self.categoryArray[0];
    
    self.dueDateString = @"";
    self.reminderDateString = @"";
    
    self.automaticallyAdjustsScrollViewInsets = NO; //Fix for textfield not starting from top
    
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    
    
}



#pragma mark TableView Delegate

//Number of rows in table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    else if(section ==1){
        [self.arrayOfCellNames removeAllObjects];
        [self.arrayOfCellNames addObjectsFromArray:[NSArray arrayWithObjects:@"dateCell", @"reminderCell", nil]];
        if (self.isDueDatePickerEnabled) {
            [self.arrayOfCellNames removeAllObjects];
            [self.arrayOfCellNames addObjectsFromArray:[NSArray arrayWithObjects:@"dateCell", @"dueDatePickerCell", @"reminderCell", nil]];
            return 3;
        }
        else if (self.isReminderDatePickerEnabled) {
            [self.arrayOfCellNames removeAllObjects];
            [self.arrayOfCellNames addObjectsFromArray:[NSArray arrayWithObjects:@"dateCell", @"reminderCell", @"reminderDatePickerCell", nil]];
            return 3;
        }
            return 2;
    }
    else{
        return 1;
    }
}

//Number of sections in table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//Cells in table view

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row ==0 && indexPath.section == 0)
    {
        ACCategoryTableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        self.selectedCategory.imageName = @"inboxIcon.png";
        self.selectedCategory.color = [UIColor whiteColor];
        [categoryCell setupCellWithCategoryName:self.selectedCategory.name categoryImageName:self.selectedCategory.imageName categoryColor:self.selectedCategory.color];
        
        return categoryCell;
    }
    
    if (indexPath.section == 1)
    {
        NSString *currentCell = [self.arrayOfCellNames objectAtIndex:indexPath.row];
        if([currentCell isEqualToString:@"dateCell"])
    {
        ACDueDateTableViewCell *dueDateCell = [tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
        
        //Check and display current date if dueDatePickerIsEnabled
        if (self.selectedDueDate == NO && self.isDueDatePickerEnabled == YES) {
            [dueDateCell setupCellWithDueDate:[[ACDueDate dateFormat] stringFromDate:[NSDate date]] forEnabledState:self.taskDueDateIsSet];
        }
        else{
            [dueDateCell setupCellWithDueDate:self.dueDateString forEnabledState:self.taskDueDateIsSet];
        }
        
        dueDateCell.delegate = self;

        return dueDateCell;
    }
        else if([currentCell isEqualToString:@"dueDatePickerCell"] || [currentCell isEqualToString:@"reminderDatePickerCell"])
        {
            ACDueDatePickerCell *dueDatePickerCell= [tableView dequeueReusableCellWithIdentifier:@"dueDatePickerCell" forIndexPath:indexPath];
            dueDatePickerCell.datePicker.backgroundColor = [UIColor greenColor];
            if (self.isDueDatePickerEnabled) {
            dueDatePickerCell.datePicker.datePickerMode = UIDatePickerModeDate;
            [dueDatePickerCell.datePicker addTarget:self action:@selector(dueDateDidChange:) forControlEvents:UIControlEventValueChanged];
                if (self.selectedDueDate == nil) {
                    dueDatePickerCell.datePicker.date = [NSDate date];
                    self.selectedDueDate = [NSDate date];
                    self.dueDateString = [[ACDueDate dateFormat] stringFromDate:self.selectedDueDate];
                    
                }
            }
            else if (self.isReminderDatePickerEnabled) {
                dueDatePickerCell.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                [dueDatePickerCell.datePicker addTarget:self action:@selector(reminderDateDidChange:) forControlEvents:UIControlEventValueChanged];
                if (self.selectedReminderDate == nil) {
                    dueDatePickerCell.datePicker.date = [NSDate date];
                    self.selectedReminderDate = [NSDate date];
                    self.reminderDateString = [[ACReminder dateFormat] stringFromDate:self.selectedDueDate];
                    
                }
            }


            return dueDatePickerCell;
        }
    
    else if([currentCell isEqualToString:@"reminderCell"])
    {
        ACReminderDateTableViewCell *reminderDateCell= [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];

        //Check and display current date if dueDatePickerIsEnabled
        if (self.selectedReminderDate == NO && self.isReminderDatePickerEnabled == YES) {
            [reminderDateCell setupCellWithReminderDate:[[ACReminder dateFormat] stringFromDate:[NSDate date]] forEnabledState:self.taskReminderIsSet];
        }
        else{
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
    
    return  nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDueDatePickerEnabled == YES && indexPath.section == 1 && indexPath.row == 1) {
        return 150;
    }
    else if (self.isReminderDatePickerEnabled == YES && indexPath.section == 1 && indexPath.row == 2) {
        return 150;
    }
    return 44;
}

//Selected cells in table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyboard];
    
    if (indexPath.row ==0 && indexPath.section ==0)
    {
        [self performSegueWithIdentifier:@"pushToAddCategory" sender:tableView];
    }
    
    if([[[self.tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"dateCell"])
    {
        
        if (self.isDueDatePickerEnabled) {
            self.isDueDatePickerEnabled = NO;
            [self performSelector:@selector(didFinishEditingDueDate:) withObject:nil];
        }
        else if (!self.isDueDatePickerEnabled){
            self.isDueDatePickerEnabled = YES;
            self.isReminderDatePickerEnabled = NO;
            self.taskDueDateIsSet = YES;
            
        }
        [self.tableView reloadData];
    }
    
    else if([[[self.tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"timeCell"])
    {
        
        if (self.isReminderDatePickerEnabled) {
            self.isReminderDatePickerEnabled = NO;
            [self performSelector:@selector(didFinishEditingReminderTime:) withObject:nil];
        }
        else if (!self.isReminderDatePickerEnabled){
            self.isReminderDatePickerEnabled = YES;
            self.isDueDatePickerEnabled = NO;
            self.taskReminderIsSet = YES;
            
        }
        [self.tableView reloadData];
    }
    
    else if (indexPath.row == 1 && indexPath.section == 1)
    {
    }
}

#pragma mark DatePicker Methods

-(void)dueDateDidChange:(UIDatePicker *)sender
{
    self.dueDateString = [[ACDueDate dateFormat] stringFromDate:sender.date];
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

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    if (self.isDueDatePickerEnabled) {
        return NO;
    }
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionClipCenter;
    swipeSettings.keepButtonsSwiped = YES;
    expansionSettings.buttonIndex = 0;
    expansionSettings.threshold = 1.5;
    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
    expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunctionCubicOut;
    expansionSettings.fillOnTrigger = NO;
    
    UIColor *redColor = [UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0];
     if (direction == MGSwipeDirectionRightToLeft){
        MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:redColor padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            if([self.tableView indexPathForCell:cell].row == 0 && [self.tableView indexPathForCell:cell].section == 1)
            {
            [self performSelector:@selector(didDeleteDueDate:) withObject:nil];
            }
            if([self.tableView indexPathForCell:cell].row == 1 && [self.tableView indexPathForCell:cell].section == 1)
            {
                [self performSelector:@selector(didDeleteReminderTime:) withObject:nil];
            }
            return YES;
        }];
        return @[deleteButton];
    }
    
    return nil;
    
}


#pragma mark Create array for IndexPath

-(NSArray *)arrayForIndexPath:(int)aRow section:(int)aSection
{
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:aRow inSection:aSection]];;
}


#pragma mark ACSelectCategoryViewControllerDelegate

-(void)selectedCategory:(ACCategory *)category allCategories:(NSMutableArray *)allCategoriesArray
{
    [self.navigationController popViewControllerAnimated:TRUE];
    self.categoryArray = allCategoriesArray;
    self.selectedCategory = category;
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ACSelectCategoryViewController class]]) {
        ACSelectCategoryViewController *selectCategoryViewController = segue.destinationViewController;
        selectCategoryViewController.categoryArray = self.categoryArray;
        selectCategoryViewController.delegate = self;
    }
}

#pragma mark Button Actions

- (IBAction)didPressCancelButton:(UIBarButtonItem *)sender
{
    [self.delegate taskAddingCancelled];
}

- (IBAction)didPressAddButton:(UIBarButtonItem *)sender
{
    [self countNumberOfLines];
    self.task = [[ACTask alloc] initWithText:self.taskTextField.text description:self.taskDescriptionTextField.text category:self.selectedCategory priority:self.selectedPriority reminderDate:self.selectedReminderDate dueDate:self.selectedDueDate lineCount:self.numberOfLines];
    if (![self.task.text isEqualToString:@""]  && self.isInEditingMode == FALSE) {
        [self.delegate taskAdded:self.task isEditing:FALSE categoriesList:self.categoryArray];
    }
    
    else if (![self.task.text isEqualToString:@""]  && self.isInEditingMode == TRUE) {
        [self.delegate taskAdded:self.task isEditing:TRUE categoriesList:self.categoryArray];
        
    }
    
    else{
        [self.delegate taskAddingCancelled];
    }
}


#pragma mark Dismiss Keyboard

- (IBAction)didSwipeDown:(UISwipeGestureRecognizer *)sender
{
    [self dismissKeyboard];
    
}

-(void)dismissKeyboard
{
    if ([self.taskTextField isFirstResponder]) {
        [self.taskTextField resignFirstResponder];
    }
    else if ([self.taskDescriptionTextField isFirstResponder]){
        [self.taskDescriptionTextField resignFirstResponder];
    }
}

#pragma mark Switch and Segment Methods

- (IBAction)didSelectPriority:(UISegmentedControl *)sender
{
    self.selectedPriority = (int) sender.selectedSegmentIndex;
}



#pragma mark TextView Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{

    [self countNumberOfLines];
    
}

-(void)countNumberOfLines{
    NSLayoutManager *layoutManager = [self.taskTextField layoutManager];
    unsigned numberOfLines, index, numberOfGlyphs = (unsigned int) [layoutManager numberOfGlyphs];
    NSRange lineRange;
    for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
        (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
                                               effectiveRange:&lineRange];
        index = (unsigned int) NSMaxRange(lineRange);
    }
    self.numberOfLines = numberOfLines;
}

@end
