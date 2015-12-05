//
//  ACViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 02/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACViewController.h"
#import "MGSwipeButton.h"

@interface ACViewController ()

@property (strong, nonatomic) ACTask *selectedTask;
@property (nonatomic) BOOL didSelectTaskForEditing;
@property (nonatomic) int selectedIndex;
@property (strong, nonatomic) ACCategory *currentCategory;
@property (strong, nonatomic) NSMutableArray *arrayOfSortedDates;
@property (strong, nonatomic) NSMutableDictionary *dictionaryContainingArrayOfSortedDates;
@property (nonatomic) int keyboardHeight;



@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:(6.0/255.0) green:(14.0/255.0) blue:(22.0/255.0) alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithRed:(45.0/255.0) green:(46.0/255.0) blue:(48.0/255.0) alpha:1];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 65.0, 0, 0)];
    
    if (!self.allTasksList) self.allTasksList = [[NSMutableArray alloc] init];
    if (!self.allCategoriesList) self.allCategoriesList = [[NSMutableArray alloc] init];
    if (!self.currentCategoriesList) self.allCategoriesList = [[NSMutableArray alloc] init];

    
    ACCategory *overview = [[ACCategory alloc] init];
    overview.name = @"Overview";
    ACCategory *allTasks = [[ACCategory alloc] init];
    allTasks.name = @"All Tasks";
    ACCategory *inbox = [[ACCategory alloc] init];
    inbox.name = @"Inbox";
    ACCategory *home = [[ACCategory alloc] init];
    home.name=@"Home";
    ACCategory *work = [[ACCategory alloc] init];
    work.name=@"Work";
    ACCategory *shopping = [[ACCategory alloc] init];
    shopping.name=@"Shopping";
    [self.allCategoriesList addObject:overview];
    [self.allCategoriesList addObject:allTasks];
    [self.allCategoriesList addObject:inbox];
    [self.allCategoriesList addObject:home];
    [self.allCategoriesList addObject:work];
    [self.allCategoriesList addObject:shopping];
    self.currentCategory = overview;
    self.currentCategoriesList = [self.allCategoriesList mutableCopy];
    [self.currentCategoriesList removeObjectsInRange:NSMakeRange(0, 2)];
    self.taskArray = self.allTasksList;
    [self.selectCategoryButton setTitle:overview.name forState:UIControlStateNormal];
    
    [self showMenuBar];
}

-(void)showMenuBar{
    self.menuBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 50)];
    self.menuBarScrollView.backgroundColor = [UIColor redColor];
    int buttonX = 0;
    for (int count = 0; count<[self.allCategoriesList count]; count++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 0, 100, 50)];
        button.backgroundColor = [UIColor greenColor];
        ACCategory *menuCategory = [self.allCategoriesList objectAtIndex:count];
        [button setTitle:[NSString stringWithFormat:@"%@",menuCategory.name] forState:UIControlStateNormal];
        button.tag = count;
        [button addTarget:self action:@selector(didPressMenuBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuBarScrollView addSubview:button];
        buttonX = buttonX + button.frame.size.width;
    }
    self.menuBarScrollView.contentSize = CGSizeMake(buttonX, 0);
    self.menuBarScrollView.showsHorizontalScrollIndicator = NO;
    self.menuBarScrollView.bounces = NO;
    
    [self.view addSubview:self.menuBarScrollView];
}

- (void)didPressMenuBarButton:(UIButton *)sender {
    [self didSelectCategory:[self.allCategoriesList objectAtIndex:sender.tag]];
}

#pragma mark TableView Delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.currentCategory.name isEqualToString:@"Overview"]) {
        return [[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:section]] count];
    }
    else{

        return  [self.taskArray count];
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.currentCategory.name isEqualToString:@"Overview"]) {
    return [self.arrayOfSortedDates count];
    }
    else{
        return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ACTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    ACTask *task;
    
    if ([self.currentCategory.name isEqualToString:@"Overview"]) {
    task =[[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    else{
        task = [self.taskArray objectAtIndex:indexPath.row];
    }
    
    cell.taskText.text = task.text;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateIntervalFormatterMediumStyle;
    cell.taskDate.text= [dateFormat stringFromDate:task.date];
    cell.categoryName.text = task.category.name;
    cell.categoryColor.image = [[UIImage imageNamed:@"categoryColorImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.categoryColor.tintColor = task.category.color;
    cell.taskText.frame =CGRectMake(cell.textLabel.frame.origin.x, (cell.taskText.frame.origin.y*task.textLineCount/5), cell.taskText.frame.size.height, cell.taskText.frame.size.height);
    cell.backgroundColor = [UIColor colorWithRed:(6.0/255.0) green:(14.0/255.0) blue:(22.0/255.0) alpha:1.0];
    cell.delegate = self;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedTask = [[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    self.didSelectTaskForEditing = TRUE;
    self.selectedIndex = (int) indexPath.row;
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self performSegueWithIdentifier:@"pushToAddTaskViewController" sender:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.currentCategory.name isEqualToString:@"Overview"]) {
    return [self.arrayOfSortedDates objectAtIndex:section];
    }
    else{
        return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACTask *task;
    if ([self.currentCategory.name isEqualToString:@"Overview"]) {
    task =[[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    else{
        task = [self.taskArray objectAtIndex:indexPath.row];
    }

    return 55.0+task.textLineCount*17.5;
}

#pragma mark ACAddTaskViewControllerDelegate

-(void)taskAddingCancelled{
    [self dismissViewControllerAnimated:TRUE completion:nil];
    [self.tableView reloadData];
    
    
}

-(void)taskAdded:(ACTask *)task isEditing:(BOOL)editing categoriesList:(NSMutableArray *)allCategoriesList{
    
    if (editing == TRUE)
    {
        [self.allTasksList removeObjectIdenticalTo:self.selectedTask];
    }
    [self showMenuBar];
    
    self.currentCategoriesList = allCategoriesList;
    [self.allCategoriesList removeObjectsInRange:NSMakeRange(2, ([self.allCategoriesList count] - 2))];
    [self.allCategoriesList addObjectsFromArray:allCategoriesList];
    [self.allTasksList addObject:task];
    [self arrangeByCategory];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
    
}

#pragma mark ACSelectCategoryToSortViewControllerDelegate

-(void)didCancelSelectingCategory{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)didSelectCategory:(ACCategory *)category{
    [self dismissViewControllerAnimated:TRUE completion:nil];
    self.currentCategory = category;
    [self.selectCategoryButton setTitle:category.name forState:UIControlStateNormal];
    [self arrangeByCategory];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushToAddTaskViewController"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ACAddTaskViewController *addTaskViewController = (ACAddTaskViewController *)navigationController.topViewController;
        addTaskViewController.delegate = self;
        addTaskViewController.categoryArray = self.currentCategoriesList;
        
        if(self.didSelectTaskForEditing == TRUE){
            addTaskViewController.isInEditingMode = TRUE;
            self.didSelectTaskForEditing = FALSE;
            addTaskViewController.taskToEdit = self.selectedTask;
        }
        
    }
    
    if ([segue.identifier isEqualToString:@"didShowSelectCategoryToSort"]) {
        ACSelectCategoryToSortViewController *selectCategoryToSortViewController = segue.destinationViewController;
        selectCategoryToSortViewController.categoryToSelectArray = self.allCategoriesList;
        selectCategoryToSortViewController.delegate = self;
        
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    ACTask *taskToMove = [[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:sourceIndexPath.section]] objectAtIndex:sourceIndexPath.row];
    NSLog(@"%d",(int) destinationIndexPath.row);

    if (destinationIndexPath.row == 0 && destinationIndexPath.section == sourceIndexPath.section && destinationIndexPath.row != sourceIndexPath.row)
    {
        ACTask *adjacentTask = [[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:destinationIndexPath.section]] objectAtIndex:(destinationIndexPath.row)];

        int indexOfAdjacentTask = (int)[self.allTasksList indexOfObject:adjacentTask];
        [self.allTasksList removeObjectIdenticalTo:taskToMove];
        [self.allTasksList removeObjectIdenticalTo:adjacentTask];
        [self.allTasksList insertObject:taskToMove atIndex:(indexOfAdjacentTask)];
        [self.allTasksList insertObject:adjacentTask atIndex:(indexOfAdjacentTask + 1)];
        [self arrangeByCategory];
        [self.tableView reloadData];

        
    }
    else if (destinationIndexPath.row != 0 && destinationIndexPath.section == sourceIndexPath.section)
    {
        ACTask *adjacentTask = [[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:destinationIndexPath.section]] objectAtIndex:(destinationIndexPath.row)];
        [self.allTasksList removeObjectIdenticalTo:taskToMove];
        int indexOfAdjacentTask = (int)[self.allTasksList indexOfObject:adjacentTask];
        [self.allTasksList replaceObjectAtIndex:indexOfAdjacentTask withObject:taskToMove];
        if(sourceIndexPath.row<destinationIndexPath.row){
        [self.allTasksList insertObject:adjacentTask atIndex:(indexOfAdjacentTask)];
        }
        else if(sourceIndexPath.row>destinationIndexPath.row){
            [self.allTasksList insertObject:adjacentTask atIndex:(indexOfAdjacentTask + 1)];
        }
        [self arrangeByCategory];
        [self.tableView reloadData];
        
        
    }
    
    else if (destinationIndexPath.row == 0 && destinationIndexPath.section != sourceIndexPath.section) {
        ACTask *adjacentTask = [[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:destinationIndexPath.section]] objectAtIndex:(destinationIndexPath.row)];
        taskToMove.date = adjacentTask.date;
        taskToMove.dateString = adjacentTask.dateString;
        [self.allTasksList removeObjectIdenticalTo:taskToMove];
        int indexOfAdjacentTask = (int)[self.allTasksList indexOfObject:adjacentTask];
        [self.allTasksList replaceObjectAtIndex:indexOfAdjacentTask withObject:taskToMove];
            [self.allTasksList insertObject:adjacentTask atIndex:(indexOfAdjacentTask+1)];
        [self arrangeByCategory];
        [self.tableView reloadData];
        
        
    }
    else if (destinationIndexPath.row != 0 && destinationIndexPath.section != sourceIndexPath.section) {
        
    }
    
    [self removeEmptySections];

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark Arrange Tasks by Category & Date

-(void)arrangeByCategory
{

    self.taskArray = [[NSMutableArray alloc] init];
    if ([self.currentCategory.name isEqualToString:@"Overview"])
    {
        self.taskArray = self.allTasksList;
    }
    else
    {
        for (ACTask *task in self.allTasksList)
        {
            
            if ([self.currentCategory.name isEqualToString:task.category.name])
            {
                [self.taskArray addObject:task];
            }
        }
    }

    if ([self.currentCategory.name isEqualToString:@"Overview"]){
        [self arrangeByDate];
        [self arrangeIntoSectionsByDate];
    }
    else{
        [self arrangeByPriorityOfTasks];
    }
}

-(void)arrangeByDate
{
    NSLog(@"arrangeByDate Method Called");
    self.taskArray = [[self.taskArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateString" ascending:YES]]] mutableCopy];

}


-(void)arrangeIntoSectionsByDate
{
    NSLog(@"arrangeIntoSectionsByDate Method Called");

    for (ACTask *task in self.taskArray) {
        BOOL breakOuterLoop = NO;
        BOOL containsDate = NO;
        if(task.date){
        if (!self.arrayOfSortedDates) {
            self.arrayOfSortedDates = [NSMutableArray array];
            [self.arrayOfSortedDates addObject:task.dateString];
            break;
        }
        for (NSString *stringContainingDate in self.arrayOfSortedDates) {

            if ([stringContainingDate isEqualToString:task.dateString] == NO && breakOuterLoop == NO) {
                containsDate = NO;
            }
            else{
                containsDate = YES;
                breakOuterLoop = YES;

            }
        }
        if (containsDate == NO)[self.arrayOfSortedDates addObject:task.dateString];
        
    }

    }
    [self arrangeArrayIntoSectionsByDate];

}


-(void)arrangeArrayIntoSectionsByDate
{
    self.dictionaryContainingArrayOfSortedDates = [NSMutableDictionary dictionary];
    for (NSString *string in self.arrayOfSortedDates) {
        NSMutableArray *array = [NSMutableArray array];
        [self.dictionaryContainingArrayOfSortedDates setValue:array forKey:string];
    }
    for (ACTask *task in self.taskArray) {
        for (NSString *stringContainingDate in self.arrayOfSortedDates) {
            if ([stringContainingDate isEqualToString:task.dateString]) {
                [[self.dictionaryContainingArrayOfSortedDates objectForKey:stringContainingDate] addObject:task];
            }
        }
    }
    NSLog(@"arrangeArrayIntoSectionsByDate  Called");
    [self arrangeByPriorityOfTasks];

}

-(void)arrangeByPriorityOfTasks
{
    NSLog(@"arrangeByPriorityOfTasks Method Called");
    if ([self.currentCategory.name isEqualToString:@"Overview"]){
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
    for (NSString *dateString in self.dictionaryContainingArrayOfSortedDates) {
        NSMutableArray *arrayContainingTasks = [self.dictionaryContainingArrayOfSortedDates objectForKey:dateString];

            [tempDictionary setObject:[[arrayContainingTasks sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"priority.number" ascending:NO]]] mutableCopy] forKey:dateString];
    }
        [self.dictionaryContainingArrayOfSortedDates removeAllObjects];
        self.dictionaryContainingArrayOfSortedDates = [tempDictionary mutableCopy];
    }

    else{
        NSMutableArray *tempArray = [self.taskArray mutableCopy];
        [self.taskArray removeAllObjects];
    self.taskArray = [[tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"priority.number" ascending:NO]]] mutableCopy];
    }

    [self.tableView reloadData];

}

#pragma mark Swipe Delegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionClipCenter;
    swipeSettings.keepButtonsSwiped = NO;
    expansionSettings.buttonIndex = 0;
    expansionSettings.threshold = 1.0;
    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
    expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunctionCubicOut;
    expansionSettings.fillOnTrigger = NO;
    
    UIColor *greenColor = [UIColor colorWithRed:33/255.0 green:175/255.0 blue:67/255.0 alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0];
    
    if (direction == MGSwipeDirectionLeftToRight) {
        MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:redColor padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSLog(@"Row:%d , Section:%d",(int)indexPath.row, (int)indexPath.section);
            if ([self.currentCategory.name isEqualToString:@"Overview"]) {
            ACTask *selectedTask = [[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            [[self.dictionaryContainingArrayOfSortedDates objectForKey:[self.arrayOfSortedDates objectAtIndex:indexPath.section]] removeObjectAtIndex:indexPath.row];
                [self.taskArray removeObjectIdenticalTo:selectedTask];
                [self.allTasksList removeObjectIdenticalTo:selectedTask];
                [self removeEmptySections];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else{
                ACTask *selectedTask = [self.taskArray objectAtIndex:indexPath.row];
                [self.taskArray removeObjectIdenticalTo:selectedTask];
                [self.allTasksList removeObjectIdenticalTo:selectedTask];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            }
            return YES;
        }];
        
        return @[deleteButton];
    }
    else if (direction == MGSwipeDirectionRightToLeft){
        
        MGSwipeButton *completedButton = [MGSwipeButton buttonWithTitle:@"Completed" backgroundColor:greenColor padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            return YES; //don't autohide to improve delete animation
        }];
        return @[completedButton];
    }
    
    return nil;

}

-(void)removeEmptySections{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in self.dictionaryContainingArrayOfSortedDates) {
        if ([[self.dictionaryContainingArrayOfSortedDates objectForKey:key] count] == 0) {
            [array addObject:key];
        }
    }
    [self.dictionaryContainingArrayOfSortedDates removeObjectsForKeys:array];
    [self.arrayOfSortedDates removeObjectsInArray:array];
    NSLog(@"%@",self.arrayOfSortedDates);
    [self.tableView reloadData];
}

- (IBAction)addNewTask:(UIButton *)sender {
    if (self.tableView.editing == NO) {
        [self.tableView setEditing:YES animated:TRUE];
    }
    else if (self.tableView.editing == YES) {
        [self.tableView setEditing:NO animated:TRUE];
    }
//    [self.addNewButton removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    UITextField* header = [[UITextField alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height, [[UIScreen mainScreen]bounds].size.width, 40)];
//    [header setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:header];
//    [self.view bringSubviewToFront:header];
//    [header becomeFirstResponder];
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        header.frame = CGRectMake(0, ([[UIScreen mainScreen]bounds].size.height-self.keyboardHeight-30), [[UIScreen mainScreen]bounds].size.width, 30);
//    } completion:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

@end
