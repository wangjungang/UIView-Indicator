//
//  BaseTableViewCell.m
//  UIView+Indicator
//
//  Created by 王祥伟 on 2018/3/12.
//  Copyright © 2018年 王祥伟. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView{
    NSString *cellID = NSStringFromClass([self class]);
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}

+ (instancetype)initWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier{
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
        
    }
    return self;
}

- (void)setUpSubViews{
    
}


@end
