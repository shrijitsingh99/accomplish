//
//  ACViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACViewController.h"
#import "ACAddTaskViewController.h"
#import "ACTask.h"
#import "ACTableViewCell.h"
#import "MGSwipeButton.h"

@interface ACViewController () <UITableViewDataSource, UITableViewDelegate, ACAddTaskViewControllerDelegate, ACSelectCategoryViewControllerDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *selectCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *addNewButton;
@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSMutableArray *visibleTasks;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) ACCategory *category;
@property (nonatomic) BOOL didSelectTaskForEditing;
@property (strong, nonatomic) NSMutableArray *arrayOfSortedDates;
@property (strong, nonatomic) NSMutableArray *dates;

@end


@implementation ACViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [ACCategory setupCategories];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 54.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.categories = [[ACCategory fetchCategories] mutableCopy];
    self.tasks = [[ACTask fetchTasks] mutableCopy];
    self.dates = [[ACDueDate fetchDueDates] mutableCopy];
    self.category = [self.categories objectAtIndex:0];
    [self.selectCategoryButton setTitle:self.category.name forState:UIControlStateNormal];
    [self arrangeTasks];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.category.name isEqualToString:@"Overview"])
    {
        return [[self.visibleTasks objectAtIndex:section] count];
    }
    else
    {
        return [self.visibleTasks count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.category.name isEqualToString:@"Overview"])
    {
        return [self.visibleTasks count];
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ACTask *task;
    if ([self.category.name isEqualToString:@"Overview"])
    {
        task = [[self.visibleTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        task = [self.visibleTasks objectAtIndex:indexPath.row];
    }
    cell.taskText.text = task.name;
    cell.taskDate.text = task.dueDate.dateString;
    cell.categoryName.text = task.category.name;
    cell.categoryColorLabel.backgroundColor = task.category.color;
    [self setTaskPriorityLabel:cell.taskPriority forPriority:[task.priority intValue]];
    cell.delegate = self;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self performSegueWithIdentifier:@"pushToAddTaskViewController" sender:nil];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.category.name isEqualToString:@"Overview"])
    {
        return [(ACDueDate *)[self.dates objectAtIndex:section] dateString];
    }
    else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return  30.0;
    }
    else
    {
        return 12.0;
    }
}


#pragma mark ACAddTaskViewControllerDelegate

-(void)taskAddingCancelled
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)taskAdded:(ACTask *)task isEditing:(BOOL)editing categoriesList:(NSMutableArray *)categories dates:(NSArray *)dates
{
    if (([self.categories count]) != [categories count])
    {
        self.categories = categories;
        [self.tableView reloadData];
        
    }
    self.dates = [dates mutableCopy];
    [self.dates sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateString" ascending:YES]]];
    [self.tasks addObject:task];
    [self arrangeTasks];

    [self.tableView reloadData];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


#pragma mark ACSelectCategoryToSortViewControllerDelegate

-(void)selectedCategory:(ACCategory *)category categories:(NSArray *)categories
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.categories count] != [categories count])
    {
        [self.categories removeAllObjects];
        self.categories = [categories mutableCopy];
    }
    if (self.category != category)
    {
        self.category = category;
        [self.selectCategoryButton setTitle:self.category.name forState:UIControlStateNormal];
        [self arrangeTasks];
    }
}

-(void)didCancelSelectingCategory:(NSArray *)categories
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.categories =  [categories mutableCopy];
    if ([self.categories count] != [categories count])
    {
        [self.categories removeAllObjects];
        [self.categories addObjectsFromArray:categories];
    }
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToAddTaskViewController"])
    {
        if ([sender isMemberOfClass:[UIBarButtonItem class]])
        {
        UINavigationController *navigationController = segue.destinationViewController;
        ACAddTaskViewController *addTaskViewController = (ACAddTaskViewController *)navigationController.topViewController;
        addTaskViewController.delegate = self;
        addTaskViewController.categories = self.categories;
        addTaskViewController.dates = self.dates;
        }
    }
    if ([segue.identifier isEqualToString:@"pushToSelectCategoryViewController"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        ACSelectCategoryViewController *selectCategoryViewController = (ACSelectCategoryViewController *)navigationController.topViewController;
        selectCategoryViewController.categories = [self.categories mutableCopy];
        selectCategoryViewController.delegate = self;
    }
}


#pragma mark Arrange Tasks

-(void)arrangeTasks
{
    if ([self.category.name isEqualToString:@"Overview"])
    {
        self.visibleTasks = [ACTask arrangeTasks:self.tasks byDueDateIntoSections:self.dates];
    }
    else
    {
        self.visibleTasks = [ACTask tasks:self.tasks ofCategory:self.category];
    }
    [self.tableView reloadData];
}


#pragma mark Swipe Delegate

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction;
{
    return YES;
}

-(NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings *)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionClipCenter;
    swipeSettings.keepButtonsSwiped = NO;
    expansionSettings.buttonIndex = 0;
    expansionSettings.threshold = 1.0;
    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
    expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunctionCubicOut;
    expansionSettings.fillOnTrigger = NO;
    UIColor *greenColor = [UIColor colorWithRed:(33 / 255.0) green:(175 / 255.0) blue:(67 / 255.0) alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:1.0 green:(59 / 255.0) blue:(50 / 255.0) alpha:1.0];
    if (direction == MGSwipeDirectionLeftToRight)
    {
        MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:redColor padding:15 callback:^BOOL(MGSwipeTableCell *sender)
        {
            NSIndexPath *index =[self.tableView indexPathForCell:cell];
            ACTask *taskToRemove;
            if ([self.category.name isEqualToString:@"Overview"])
            {
                taskToRemove = [[self.visibleTasks objectAtIndex:index.section] objectAtIndex:index.row];
                [[self.visibleTasks objectAtIndex:index.section] removeObjectAtIndex:index.row];
                [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
                if ([[self.visibleTasks objectAtIndex:index.section] count] == 0)
                {
                    [(ACDueDate *)[self.dates objectAtIndex:index.section] removeDueDate];
                    [self.dates removeObjectAtIndex:index.section];
                    [self.visibleTasks removeObjectAtIndex:index.section];
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            else
            {
            taskToRemove = [self.visibleTasks objectAtIndex:index.row];
            [self.visibleTasks removeObjectAtIndex:index.row];
                if([self isDateEmptyForTask:taskToRemove] == YES)
                {
                    [self removeEmptyDate:taskToRemove.dueDate];
                }
                [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
            }
            [taskToRemove removeTask];

            return YES;
        }];
        return @[ deleteButton ];
    }
    else if (direction == MGSwipeDirectionRightToLeft)
    {
        MGSwipeButton *completedButton = [MGSwipeButton buttonWithTitle:@"Completed" backgroundColor:greenColor padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            return YES;
        }];
        return @[ completedButton ];
    }
    return nil;
}


-(BOOL)isDateEmptyForTask:(ACTask *)task
{
    for (ACTask *taskToCheck in self.visibleTasks) {
        if (task.dueDate == taskToCheck.dueDate) {
            return NO;
        }
    }
    return YES;
}

-(void)removeEmptyDate:(ACDueDate *)date
{
    for (ACDueDate *dateToCheck in self.dates) {
        if([dateToCheck.dateString isEqualToString:date.dateString])
        {
            [self.dates removeObject:dateToCheck];
            [dateToCheck removeDueDate];
        }
    }
}

#pragma mark Priority Method

-(void)setTaskPriorityLabel:(UILabel *)label forPriority:(int)priority
{
    if (priority == 0)
    {
        label.text = @"";
    }
    else if (priority == 1)
    {
        label.text = @"!";
        label.textColor = [UIColor yellowColor];
    }
    else if (priority == 2)
    {
        label.text = @"!!";
        label.textColor = [UIColor orangeColor];
    }
    else if (priority == 3)
    {
        label.text = @"!!!";
        label.textColor = [UIColor redColor];
    }
}
#pragma mark Lazy Initialization

-(NSMutableArray *)visibleTasks
{
    if (!_visibleTasks) _visibleTasks = [[NSMutableArray alloc] init];
        return _visibleTasks;
}

@end
