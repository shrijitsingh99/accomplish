//
//  ACSelectCategoryViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 03/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACSelectCategoryViewController.h"
#import "MGSwipeButton.h"
#import "ACSelectCategoryTableViewCell.h"


@interface ACSelectCategoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *oldIndex;

-(IBAction)didPresCancelBarButtonItem:(UIBarButtonItem *)sender;

@end


@implementation ACSelectCategoryViewController

-(void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
}

-(void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.categories count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ACSelectCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	ACCategory *category =  self.categories[indexPath.row];
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
	if ([category.name isEqualToString:@"DUMMY"])
    {
		cell.categoryNameLabel.text = @"";
	}
	cell.categoryNameLabel.text = category.name;
    cell.categoryColorLabel.backgroundColor = category.color;
	cell.delegate = self;
	return cell;
}


#pragma mark MGSwipTableCell Delegate Methods

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point
{
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
	expansionSettings.fillOnTrigger = YES;
    UIColor *redColor = [UIColor colorWithRed:1.0 green:(59 / 255.0) blue:(50 / 255.0) alpha:1.0];
	if (direction == MGSwipeDirectionRightToLeft)
    {
		MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:redColor padding:15 callback:^BOOL (MGSwipeTableCell *sender)
        {
            dispatch_queue_t removeObjectFromCoreData = dispatch_queue_create("removeObjectFromCoreData", NULL);
            dispatch_async(removeObjectFromCoreData, ^
            {
                [(ACCategory *)[self.categories objectAtIndex:[self.tableView indexPathForCell:cell].row] removeCategory];
				dispatch_async(dispatch_get_main_queue(), ^
                {
					[self.categories removeObjectAtIndex:[self.tableView indexPathForCell:cell].row];
					[self.tableView reloadData];
				});
			});
            return YES;
        }];
		return @[deleteButton];
	}
	return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate selectedCategory:self.categories[indexPath.row] categories:self.categories];
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	ACCategory *categoryToBeMoved = [self.categories objectAtIndex:sourceIndexPath.row];
	[self.categories removeObjectAtIndex:sourceIndexPath.row];
	[self.categories insertObject:categoryToBeMoved atIndex:destinationIndexPath.row];

	int serial = 0;
	for (ACCategory *category in self.categories)
    {
		category.serial = [NSNumber numberWithInt:serial];
		serial++;
	}
}


#pragma mark BVReorderTableView Delegate Methods

-(id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCategory *category = [self.categories objectAtIndex:indexPath.row];
    self.oldIndex = indexPath;
    [self.categories replaceObjectAtIndex:indexPath.row withObject:[ACCategory insertCategoryWithName:@"DUMMY" color:nil serial:nil]];
    return category;
}

-(void)finishReorderingWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    [ACCategory removeCategories:@[[self.categories objectAtIndex:self.oldIndex.row]]];
    [self.categories removeObjectAtIndex:self.oldIndex.row];
    [self.categories insertObject:object atIndex:indexPath.row];
     self.categories = [[ACCategory changeCategorySequenceforCategories:self.categories] mutableCopy];
}


#pragma mark ACAddTaskViewController Delegate Methods

-(void)categoryAddingCancelled
{
	[self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)categoryAdded:(ACCategory *)category
{
	[self dismissViewControllerAnimated:TRUE completion:nil];
	[self.categories addObject:category];
	[self.tableView reloadData];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.destinationViewController isKindOfClass:[ACAddCategoryViewController class]])
    {
        if ([sender isMemberOfClass:[UIBarButtonItem class]])
        {
		ACAddCategoryViewController *addCategoryViewController = segue.destinationViewController;
		addCategoryViewController.serialForCategoryToBeAdded = (int) [self.categories count];
		addCategoryViewController.delegate = self;
        }
	}
}

-(IBAction)didPresCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate didCancelSelectingCategory:self.categories];
}

@end
