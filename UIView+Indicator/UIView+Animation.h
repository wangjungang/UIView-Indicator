//
//  UIView+Animation.h
//  UIView+Indicator
//
//  Created by 王祥伟 on 2018/3/7.
//  Copyright © 2018年 王祥伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (Animation)

//The animation view
@property (nonatomic, strong) UIImageView *animationImageView;

//Animation array, support NSString,NSURL,UIImage
@property (nonatomic, copy) NSArray *animationImages;

//Animation timeInterval default 1.0
@property (nonatomic) NSTimeInterval animationTime;

//MBProgressHUD+
@property (nonatomic) MBProgressHUD *HUD;

//Animation start
- (void)showAnimation;

//Animation remove
- (void)removeAnimation;

//HUD show
- (void)showHUD;

//HUD show text
- (void)showHUDText:(NSString *)text delay:(CGFloat)delay;

//HUD remove
- (void)removeHUD;

@end
