//
//  TableViewCell.m
//  UIView+Indicator
//
//  Created by 王祥伟 on 2018/3/12.
//  Copyright © 2018年 王祥伟. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)setUpSubViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, 200, 20)];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.view];
    [self.contentView addSubview:self.label];
}

@end
