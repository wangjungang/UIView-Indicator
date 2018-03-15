//
//  ViewController.m
//  UIView+Indicator
//
//  Created by 王祥伟 on 2018/3/7.
//  Copyright © 2018年 王祥伟. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Animation.h"
#import "TableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 120;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.hidden = YES;
   
    NSMutableArray *temp = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [temp addObject:image];
    }
    
    
    NSString *string1 = @"20182172015064064.gif";
    NSString *string2 = @"http://img.zcool.cn/community/016ea057314efc0000002bf08c5256.gif";
    NSString *string3 = @"http://bpic.ooopic.com/12/42/25/02bOOOPIC95_1024.jpg!/fw/750/quality/90/unsharp/true/compress/true/format/jpg";
    NSString *string4 = @"9-160Q2215I3";
    self.images = @[@[string1],@[string2],@[string3],@[string4],temp];
    self.titles = @[@"我是本地gif动态图",@"我是网络动态图",@"我是网络图片",@"我是本地图片",@"我是一组图片"];
    
    [self.view showHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view removeHUD];
        self.tableView.hidden = NO;
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [TableViewCell initWithTableView:tableView];
    
    [cell.view showHUD];
    cell.view.HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    cell.view.HUD.bezelView.color =  [UIColor clearColor];
    
    NSTimeInterval time = indexPath.row + 2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.view.animationImages = self.images[indexPath.row];
        [cell.view showAnimation];
        if (indexPath.row == 4) {
            cell.view.animationImageView.frame = CGRectMake((cell.view.frame.size.width-50)/2, (cell.view.frame.size.height-50)/2, 50, 50);//这里需要放在showAnimation之后
        }
    });
 
    cell.label.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd",indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
