//
//  SPDemoViewController.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/30.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "SPDemoViewController.h"

@interface SPDemoViewController ()

@end

@implementation SPDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (SPNavigationBarBackgroundStyle)navigationBarBackgroundStyle {
    return SPNavigationBarBackgroundStyleTranslucent;
}

- (NSDictionary<NSString *,UIImage *> *)navigationBackgroundImage {
    if (!self.imageName || !self.image) {
        return nil;
    }
    return @{self.imageName:[self.image resizableImageWithCapInsets:UIEdgeInsetsZero
                                                       resizingMode:UIImageResizingModeStretch]};
}

- (UIColor *)navigationBackgroundColor {
    return self.color;
}

- (UIBarStyle)navigationBarStyle {
    return UIBarStyleBlack;
}

//- (BOOL)navigationDragBack {
//    return NO;
//}

@end
