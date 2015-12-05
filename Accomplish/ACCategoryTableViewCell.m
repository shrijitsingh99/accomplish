//
//  ACCategoryTableViewCell.m
//  Accomplish
//
//  Created by Shrijit Singh on 18/11/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACCategoryTableViewCell.h"

@implementation ACCategoryTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
    
}

-(void)setupCellWithCategoryName:(NSString *)aName categoryImageName:(NSString *)anImageName categoryColor:(UIColor *)aColor{
    _categoryNameLabel.text = aName;
    _categoryIconImageView.image = [[UIImage imageNamed:anImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _categoryIconImageView.tintColor = aColor;
    
}


@end
