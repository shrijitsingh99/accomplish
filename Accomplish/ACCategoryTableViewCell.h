//
//  ACCategoryTableViewCell.h
//  Accomplish
//
//  Created by Shrijit Singh on 18/11/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ACCategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *categoryIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *categoryColorImageView;

-(void)setupCellWithCategoryName:(NSString *)name categoryImage:(NSString *)imageName categoryColor:(UIColor *)color;

@end
