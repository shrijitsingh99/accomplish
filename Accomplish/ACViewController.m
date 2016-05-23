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
#import "UIApplication+CoreData.h"

@interface ACViewController () <UITableViewDataSource, UITableViewDelegate, ACAddTaskViewControllerDelegate, ACSelectCategoryViewControllerDelegate, MGSwipeTableCellDelegate, NSFetchedResultsControllerDelegate>

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

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;



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
    self.category = [self.categories objectAtIndex:0];
    [self.selectCategoryButton setTitle:self.category.name forState:UIControlStateNormal];
    
    [self performFetchForCurrentCategory];

}

#pragma mark NSFetchedResultsController Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(ACTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationRight];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationRight];
            break;
        }
    }
}

-(void)configureCell:(ACTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
    {
        ACTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.taskText.text = task.name;
        cell.taskDate.text = task.dueDate.dateString;
        cell.categoryName.text = task.category.name;
        cell.categoryColorLabel.backgroundColor = task.category.color;
        [self setTaskPriorityLabel:cell.taskPriority forPriority:[task.priority intValue]];
        cell.delegate = self;
    }

#pragma mark UITableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACTableViewCell *cell = (ACTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure Table View Cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.numberOfSections > 0 && [self.category.name isEqualToString:@"Overview"]) {
        ACTask *task = [[[[self.fetchedResultsController sections] objectAtIndex:section] objects] objectAtIndex:0];
        return task.dueDate.dateString;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
{
    NSMutableArray *tasks = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    ACTask *taskToReorder = [[self fetchedResultsController] objectAtIndexPath:sourceIndexPath];
    [tasks removeObject:taskToReorder];
    [tasks insertObject:taskToReorder atIndex:[destinationIndexPath row]];
    int i = 0;
    for (ACTask *task in tasks)
    {
        task.serial = [NSNumber numberWithInt:i++];
    }
    
    [self saveManagedObjectContext];
}


#pragma mark ACAddTaskViewControllerDelegate

-(void)taskAddingCancelled
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)taskAdded
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [self performFetchForCurrentCategory];
        [self.tableView reloadData];
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


#pragma mark SwipeTableCell Delegate

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction;
{
    return YES;
}

-(NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings *)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionClipCenter;
    swipeSettings.keepButtonsSwiped = YES;
    expansionSettings.buttonIndex = 0;
    expansionSettings.threshold = 1.0;
    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
    expansionSettings.fillOnTrigger = YES;
    UIColor *greenColor = [UIColor colorWithRed:(33 / 255.0) green:(175 / 255.0) blue:(67 / 255.0) alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:1.0 green:(59 / 255.0) blue:(50 / 255.0) alpha:1.0];
    if (direction == MGSwipeDirectionLeftToRight)
    {
        MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:redColor padding:15 callback:^BOOL(MGSwipeTableCell *sender)
        {
            NSIndexPath *index =[self.tableView indexPathForCell:cell];
            ACTask *taskToRemove = [self.fetchedResultsController objectAtIndexPath:index];
            if(taskToRemove)
            {
                [self.fetchedResultsController.managedObjectContext deleteObject:taskToRemove];
                [self saveManagedObjectContext];

            }
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

#pragma mark Priority Assignment Method

-(void)setTaskPriorityLabel:(UILabel *)label forPriority:(int)priority
{
    switch (priority) {
        case 1:
            label.text = @"!";
            label.textColor = [UIColor yellowColor];
            break;
        case 2:
            label.text = @"!!";
            label.textColor = [UIColor orangeColor];
            break;
        case 3:
            label.text = @"!!!";
            label.textColor = [UIColor redColor];
            break;
        default:
            label.text = @"";
            break;
    }
}
#pragma mark Helper Methods

-(void)performFetchForCurrentCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    
    if ([self.category.name isEqualToString:@"Overview"])
    {
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dueDate.date" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dueDate != nil"]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[UIApplication applicationManagedObjectContext] sectionNameKeyPath:@"dueDate.dateString" cacheName:nil];
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    }
    else
    {
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dueDate.date" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"category.name like %@", self.category.name]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[UIApplication applicationManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
    
    [self.fetchedResultsController setDelegate:self];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if(error)
    {
        NSLog(@"CoreData Error");
    }
}

- (void)saveManagedObjectContext {
    NSError *error = nil;
    
    if (![[UIApplication applicationManagedObjectContext] save:&error]) {
        if (error) {
            NSLog(@"Unable to save changes.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
}

@end
