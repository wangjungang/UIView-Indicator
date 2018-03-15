//
//  UIView+Animation.m
//  UIView+Indicator
//
//  Created by 王祥伟 on 2018/3/7.
//  Copyright © 2018年 王祥伟. All rights reserved.
//

#import "UIView+Animation.h"
#import <objc/runtime.h>
#import "YYCache.h"

static char *animationImageskey;
static char *animationImageViewKey;
static char *animationTimeKey;

static char *MBProgressHUDKey;

@implementation UIView (Animation)
@dynamic animationImageView,animationImages,animationTime;
@dynamic HUD;

#pragma mark - Public

- (void)showAnimation{
    NSArray *animationImages = objc_getAssociatedObject(self, &animationImageskey);
    if (!animationImages) return;
    UIImageView *animationView = objc_getAssociatedObject(self, &animationImageViewKey);
    if (animationView && [animationView isAnimating]) return;

    NSMutableArray *imagesArray = [NSMutableArray array];
    [animationImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSURL class]]) {
            [imagesArray addObjectsFromArray:[self gifImagesWithURL:obj]];
        }else if ([obj isKindOfClass:[NSString class]]){
            if ([obj hasPrefix:@"http://"] || [obj hasPrefix:@"https://"]) {
                NSURL *url = [NSURL URLWithString:obj];
                [imagesArray addObjectsFromArray:[self gifImagesWithURL:url]];
            }else if ([[obj pathExtension] isEqualToString:@"gif"]){
                NSArray *gifString = [obj componentsSeparatedByString:@"."];
                NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:[gifString firstObject] withExtension:[gifString lastObject]];
                [imagesArray addObjectsFromArray:[self gifImagesWithURL:gifImageUrl]];
            }else{
                UIImage *image = [UIImage imageNamed:obj];
                if (image) [imagesArray addObject:image];
            }
        }else if ([obj isKindOfClass:[UIImage class]]){
            [imagesArray addObject:obj];
        }else{
            NSAssert(NO, @"目前仅支持 NSURL,NSString,UIImage 类");
        }
    }];

    [self showWithImages:imagesArray];
}

- (void)removeAnimation{
    [self remove];
}

- (void)showHUD{
    MBProgressHUD *hud = [self isHUD];
    [hud showAnimated:YES];
}

- (void)showHUDText:(NSString *)text delay:(CGFloat)delay{
    MBProgressHUD *hud = [self isHUD];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [UIImageView new];
    if (delay > 0) [hud hideAnimated:YES afterDelay:delay];
}

- (void)removeHUD{
    MBProgressHUD *hud = [self HUD];
    if (hud) [hud hideAnimated:YES];
}

#pragma mark - According to the animation

- (void)showWithImages:(NSArray *)images{
    self.userInteractionEnabled = NO;
    UIImageView *animationView = [self isAnimationView];

    objc_setAssociatedObject(self, &animationImageViewKey, animationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    animationView.animationImages = images;
    animationView.animationRepeatCount = 0;
    animationView.animationDuration = [objc_getAssociatedObject(self, &animationTimeKey) doubleValue] ?: 1.0;
    [animationView startAnimating];
}

#pragma mark - Remove the animation

- (void)remove{
    UIImageView *animationView = objc_getAssociatedObject(self, &animationImageViewKey);
    if ([animationView isAnimating]) {
        [animationView stopAnimating];
    }
    [animationView removeFromSuperview];
    self.userInteractionEnabled = YES;
}

#pragma mark - Private

- (MBProgressHUD *)isHUD{
    MBProgressHUD *hud = [self HUD];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        objc_setAssociatedObject(self, &MBProgressHUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hud;
}

- (UIImageView *)isAnimationView{
    UIImageView *imageView = objc_getAssociatedObject(self, &animationImageViewKey);
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
    }
    return imageView;
}

- (NSMutableArray *)gifImagesWithURL:(NSURL *)url{
    YYCache *yyCache = [YYCache cacheWithName:@"animationImagesCache"];
    id value = [yyCache objectForKey:[url absoluteString]];
    if (!value) {
        NSMutableArray *gifImages = [NSMutableArray array];
        CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
        size_t gifcount = CGImageSourceGetCount(gifSource);
        for (NSInteger i = 0; i < gifcount; i++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            [gifImages addObject:image];
            CGImageRelease(imageRef);
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [yyCache setObject:gifImages forKey:[url absoluteString]];
        });
        
        return gifImages;
    }else{
        return value;
    }
}

- (UIImageView *)animationImageView{
    return [self isAnimationView];
}

- (void)setAnimationImages:(NSArray *)animationImages{
    objc_setAssociatedObject(self, &animationImageskey, animationImages, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAnimationTime:(NSTimeInterval)animationTime{
    objc_setAssociatedObject(self, &animationTimeKey, @(animationTime), OBJC_ASSOCIATION_ASSIGN);
}

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, &MBProgressHUDKey);
}

@end
