//
//  ACViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACViewController.h"
#import "ACTask.h"
#import "ACTableViewCell.h"
#import "MGSwipeButton.h"
#import "UIApplication+CoreData.h"


@interface ACViewController ()

@property (nonatomic) BOOL didSelectTaskForEditing;
@property (nonatomic) int selectedIndex;
@property (strong, nonatomic) NSMutableArray *arrayOfSortedDates;
@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation ACViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 54.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self performFirstRunSetup];
    self.categories = [[ACCategory fetchCategories] mutableCopy];
    self.dates = [[ACDueDate fetchDueDates] mutableCopy];
    self.tasks = [[ACTask fetchTasks] mutableCopy];
    self.category = [self.categories objectAtIndex:0];
    [self.selectCategoryButton setTitle:self.category.name forState:UIControlStateNormal];
    [self arrangeTasks];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)performFirstRunSetup
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults valueForKey:@"isFirstRun"])
    {
        ACCategory *overview = [ACCategory insertCategoryWithName:@"Overview" color:nil serial:0];
        ACCategory *inbox = [ACCategory insertCategoryWithName:@"Inbox" color:nil serial:1];
        ACCategory *home = [ACCategory insertCategoryWithName:@"Home" color:nil serial:2];
        ACCategory *work = [ACCategory insertCategoryWithName:@"Work" color:nil serial:3];
        ACCategory *shopping = [ACCategory insertCategoryWithName:@"Shopping" color:nil serial:4];
        [ACCategory saveCategories];
        [userDefaults setBool:YES forKey:@"isFirstRun"];
    }
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
    cell.taskDate.text = task.dueDate.date;
    cell.categoryName.text = task.category.name;
    cell.categoryColor.image = [[UIImage imageNamed:@"categoryColorImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.categoryColor.tintColor = task.category.color;
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
        return [(ACDueDate *)[self.dates objectAtIndex:section] date];
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
    [self.dates sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
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
        [self arrangeIntoSectionsByDate];
        [self.tableView reloadData];
    }
    else
    {
    self.visibleTasks = [self.tasks mutableCopy];
    [self arrangeByCategory];
    [self arrangeByPriority];
    [self arrangeByDate];
    [self.tableView reloadData];

    }
}

-(void)arrangeByCategory
{
    NSPredicate  *filterByCategory = [NSPredicate predicateWithFormat:@"category.name CONTAINS %@", self.category.name];
    self.visibleTasks = [[self.tasks filteredArrayUsingPredicate:filterByCategory] mutableCopy];
}

-(void)arrangeByPriority
{
    [self.visibleTasks sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO] ]];
}

-(void)arrangeByDate
{
    [self.visibleTasks sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dueDate.date" ascending:YES]]];
}

-(void)arrangeIntoSectionsByDate
{
    [self.visibleTasks removeAllObjects];
    for (ACDueDate *date in self.dates)
    {
        NSPredicate *filterByDatePredicate = [NSPredicate predicateWithFormat:@"dueDate.date CONTAINS %@", date.date];
        [self.visibleTasks addObject:[self.tasks filteredArrayUsingPredicate:filterByDatePredicate]];
    }
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


#pragma mark Lazy Initialization

-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return  _dateFormatter;
}

-(NSMutableArray *)visibleTasks
{
    if (!_visibleTasks) _visibleTasks = [[NSMutableArray alloc] init];
        return _visibleTasks;
}

@end
