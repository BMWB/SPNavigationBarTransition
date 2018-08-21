//
//  UIViewController+SPNavigationBarTransition.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "UIViewController+SPNavigationBarTransition.h"
#import "SPNavigationBarConfiguration.h"
#import "UINavigationBar+SPConfigure.h"
#import <objc/runtime.h>

@implementation UIViewController (SPNavigationBarTransition)

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (!self.currentBarConfigure) {
        return UIStatusBarStyleLightContent;
    }
    return self.currentBarConfigure.statusBarStyle;
}

- (BOOL)hasCustomNavigationBarStyle {
    return [self conformsToProtocol:@protocol(SPNavigationBarProtocol)];
}

- (UINavigationBar *)navigationBar {
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)self navigationBar];
    }
    
    return [self.navigationController navigationBar];
}

- (void)refreshNavigationBarStyle {
    NSParameterAssert([self hasCustomNavigationBarStyle]);
    
    UINavigationBar *navigationBar = [self navigationBar];
    
    if (navigationBar.topItem == self.navigationItem) {
        id<SPNavigationBarProtocol> owner = (id<SPNavigationBarProtocol>)self;
        
        SPNavigationBarConfiguration *configuration = [[SPNavigationBarConfiguration alloc] initWithBarConfigurationOwner:owner];
        
        [navigationBar applyBarConfiguration:configuration];
        
        self.currentBarConfigure = configuration;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (CGRect)fakeBarFrameForNavigationBar:(UINavigationBar *)navigationBar {
    if (!navigationBar || ![navigationBar backgroundView]) {
        return CGRectNull;
    }
    
    UIView *backgroundView = [navigationBar backgroundView];
    CGRect frame = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    frame.origin.x = self.view.bounds.origin.x;
    return frame;
    
}

- (SPNavigationBarConfiguration *)currentBarConfigure {
    return objc_getAssociatedObject(self, @selector(currentBarConfigure));
}

- (void)setCurrentBarConfigure:(SPNavigationBarConfiguration *)currentBarConfigure {
    objc_setAssociatedObject(self, @selector(currentBarConfigure), currentBarConfigure, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
