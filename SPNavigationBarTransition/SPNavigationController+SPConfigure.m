//
//  SPNavigationController+SPConfigure.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/30.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "SPNavigationController+SPConfigure.h"

@implementation SPNavigationController (SPConfigure)

- (SPNavigationBarBackgroundStyle)navigationBarBackgroundStyle {
    return SPNavigationBarBackgroundStyleOpaque;
}

- (UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)navigationBackgroundColor {
    return [UIColor blackColor];
}

- (BOOL)navigationBarHidden {
    return NO;
}

- (UIBarStyle)navigationBarStyle {
    return UIBarStyleBlack;
}
@end
