//
//  ACSelectCategoryViewController.m
//  Accomplish
//
//  Created by Shrijit Singh on 03/10/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACSelectCategoryViewController.h"

@interface ACSelectCategoryViewController ()

@end

@implementation ACSelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.categoryArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ACCategory *category =  self.categoryArray[indexPath.row];
    cell.textLabel.text = category.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate selectedCategory:self.categoryArray[indexPath.row] allCategories:self.categoryArray];

}

-(void)categoryAddingCancelled{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)categoryAdded:(ACCategory *)category{
    [self dismissViewControllerAnimated:TRUE completion:nil];
    [self.categoryArray addObject:category];
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ACAddCategoryViewController class]]) {
        ACAddCategoryViewController *addCategoryViewController = segue.destinationViewController;
        addCategoryViewController.delegate = self;
    }
}

@end
