//
//  ACCategoryTableViewCell.m
//  Accomplish
//
//  Created by Shrijit Singh on 18/11/15.
//  Copyright © 2015 Shrijit Singh. All rights reserved.
//

#import "ACCategoryTableViewCell.h"


@implementation ACCategoryTableViewCell

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:NO animated:animated];
}

-(ACCategoryTableViewCell *)setupCellWithCategoryName:(NSString *)name categoryImage:(NSString *)imageName categoryColor:(UIColor *)color
{
	_categoryNameLabel.text = name;
	_categoryIconImageView.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_categoryIconImageView setTintColor:color];
    
    return self;
}


@end
