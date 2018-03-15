//
//  BaseTableViewCell.h
//  UIView+Indicator
//
//  Created by 王祥伟 on 2018/3/12.
//  Copyright © 2018年 王祥伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView;

+ (instancetype)initWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier;

- (void)setUpSubViews;

@end
