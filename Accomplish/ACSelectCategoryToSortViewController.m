//
//  ACSelectCategoryToSortViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 12/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACSelectCategoryToSortViewController.h"

@interface ACSelectCategoryToSortViewController ()



@end

@implementation ACSelectCategoryToSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categoryToSelectArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ACCategory *category = self.categoryToSelectArray[indexPath.row];
    cell.textLabel.text = category.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate didSelectCategory:[self.categoryToSelectArray objectAtIndex:indexPath.row]];
    
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return NO;
    }
    else{
    return YES;
}
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{

    [self.categoryToSelectArray removeObjectAtIndex:fromIndexPath.row];
    [self.categoryToSelectArray insertObject:(self.categoryToSelectArray[fromIndexPath.row]) atIndex:toIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UITableViewCellEditingStyleDelete) {
        NSArray *indexPathArray = [[NSArray alloc] initWithObjects:indexPath, nil];
        [_categoryToSelectArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didPressCancel:(UIBarButtonItem *)sender {
    [self.delegate didCancelSelectingCategory];
}


- (IBAction)didPressEdit:(UIBarButtonItem *)sender {
    if (self.editing) {
        [self.tableView setEditing:FALSE];
        self.editing = FALSE;
        self.editButton.title = @"Edit";
    }
    else{
    [self.tableView setEditing:TRUE];
        self.editing = TRUE;
        self.editButton.title = @"Done";
    }
}
@end
