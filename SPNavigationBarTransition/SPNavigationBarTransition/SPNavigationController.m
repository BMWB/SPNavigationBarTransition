//
//  SPNavigationController.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/28.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "SPNavigationController.h"
#import "SPNavigationControllerDelegateProxy.h"
#import "SPNavigationBarTransitionCenter.h"
#import "SPNavigationBarProtocol.h"

@interface SPNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) SPNavigationBarTransitionCenter * center;
@property (weak,   nonatomic) id<UINavigationControllerDelegate> navigationDelegate;
@property (strong, nonatomic) SPNavigationControllerDelegateProxy * delegateProxy;
@property (strong, nonatomic) UIViewController * currentViewController;
@property (assign, nonatomic) BOOL isSwitching;

@end

@implementation SPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _center = [[SPNavigationBarTransitionCenter alloc] initWithDefaultBarConfiguration:[self conformsToProtocol:@protocol(SPNavigationBarProtocol)]?(id<SPNavigationBarProtocol>)self:nil];
    if (!self.delegate) {
        self.delegate = self;
    }
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    if (delegate == self || delegate == nil) {
        _navigationDelegate = nil;
        _delegateProxy = nil;
        super.delegate = self;
    } else {
        _navigationDelegate = delegate;
        _delegateProxy = [[SPNavigationControllerDelegateProxy alloc] initWithNavigationTarget:_navigationDelegate interceptor:self];
        super.delegate = (id<UINavigationControllerDelegate>)_delegateProxy;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        if (self.isSwitching) {
            return;
        }
        
        self.isSwitching = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
    // 修改tabBra的frame (目前的解决办法 2017年11月21日)
//    if (isIPhoneX)//解决push时tabbar瞬间上移的问题
//    {
//        CGRect frame = self.tabBarController.tabBar.frame;
//        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
//        self.tabBarController.tabBar.frame = frame;
//    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count>0) {
        return [super popViewControllerAnimated:animated];
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UINavigationControllerDelegate> navigationDelegate = self.navigationDelegate;
    
    if ([navigationDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [navigationDelegate navigationController:navigationController
                          willShowViewController:viewController
                                        animated:animated];
    }
    
    [_center navigationController:navigationController willShowViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UINavigationControllerDelegate> navigationDelegate = self.navigationDelegate;
    if ([navigationDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [navigationDelegate navigationController:navigationController
                           didShowViewController:viewController
                                        animated:animated];
    }
    
    [_center navigationController:navigationController
            didShowViewController:viewController
                         animated:animated];
    
    //Enable the gesture again once the new controller is shown
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    if (navigationController.viewControllers.count == 1) {
        self.currentViewController = nil;
    } else {
        self.currentViewController = viewController;
    }
    
    self.isSwitching = NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
   
    if ([self.currentViewController conformsToProtocol:@protocol(SPNavigationBarProtocol)]
        && [self.currentViewController respondsToSelector:@selector(navigationDragBack)]) {
        return [(id<SPNavigationBarProtocol>)self.currentViewController navigationDragBack];
    }
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return self.currentViewController == self.topViewController;
    }
    
    return YES;
}
@end
