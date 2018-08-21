//
//  SPNavigationBarTransitionCenter.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "SPNavigationBarTransitionCenter.h"
#import "SPNavigationBarConfiguration.h"
#import "UINavigationBar+SPConfigure.h"
#import "UIToolbar+SPConfigure.h"
#import "UIViewController+SPNavigationBarTransition.h"

//是否展示假的Bar
static inline BOOL transitionNeedShowFakeBar(SPNavigationBarConfiguration *from, SPNavigationBarConfiguration *to);

@interface SPNavigationBarTransitionCenter()<UIToolbarDelegate>

@property (nonatomic, strong) UIToolbar *fromViewControllerFakeBar;
@property (nonatomic, strong) UIToolbar *toViewControllerFakeBar;
@property (nonatomic, assign) BOOL isTransitionNavigationBar;
@property (nonatomic, strong) SPNavigationBarConfiguration  *defaultBarConfigure;

@end

@implementation SPNavigationBarTransitionCenter

- (instancetype)initWithDefaultBarConfiguration:(id<SPNavigationBarProtocol>)_default {
    self = [super init];
    if (self) {
        if (_default) {
            _defaultBarConfigure = [[SPNavigationBarConfiguration alloc] initWithBarConfigurationOwner:_default];
        } else {
            _defaultBarConfigure = [[SPNavigationBarConfiguration alloc] Default];
        }
    }
    
    return self;
}

static void * boundsContext = &boundsContext;

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    SPNavigationBarConfiguration *currentConfigure = [navigationController.navigationBar currentBarConfigure]?:self.defaultBarConfigure;
    SPNavigationBarConfiguration *showConfigure = self.defaultBarConfigure;
    
    if ([viewController hasCustomNavigationBarStyle]) {
        id<SPNavigationBarProtocol> owner = (id<SPNavigationBarProtocol>)viewController;
        
        showConfigure = [[SPNavigationBarConfiguration alloc] initWithBarConfigurationOwner:owner];
    }
    
    UINavigationBar * const navigationBar = navigationController.navigationBar;
    
    BOOL showFakeBar = transitionNeedShowFakeBar(currentConfigure, showConfigure);
    _isTransitionNavigationBar = YES;
    
    if (showConfigure.hidden != navigationController.navigationBarHidden) {
        [navigationController setNavigationBarHidden:showConfigure.hidden animated:animated];
    }
    
    SPNavigationBarConfiguration *transparentConfigure = nil;
    
    if (showFakeBar) {
        transparentConfigure = [[SPNavigationBarConfiguration alloc] initWithBarBackgroundStyle:SPNavigationBarBackgroundStyleTransparent
                                                                                      tintColor:showConfigure.tintColor
                                                                                backgroundColor:nil
                                                                                backgroundImage:nil
                                                                      backgroundImageIdentifier:nil
                                                                                       barStyle:showConfigure.statusBarStyle barHidden:showConfigure.hidden titleAttributes:showConfigure.titleAttributes];
    }
    
    if (!showConfigure.hidden) {
        [navigationBar applyBarConfiguration:transparentConfigure?:showConfigure];
        viewController.currentBarConfigure = transparentConfigure?:showConfigure;
    } else {
        [navigationBar adjustWithBarStyle:currentConfigure.barStyle
                                tintColor:currentConfigure.tintColor
                          titleAttributes:currentConfigure.titleAttributes];
        viewController.currentBarConfigure = currentConfigure;
    }
    
    [viewController setNeedsStatusBarAppearanceUpdate];
    
    if (!animated) {
        return;
    }
    
    [navigationController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        if (showFakeBar) {
            [UIView setAnimationsEnabled:NO];
            
            UIViewController * const fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController * const toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            
            if (fromVC && [currentConfigure isVisible]) {
                CGRect fakeBarFrame = [fromVC fakeBarFrameForNavigationBar:navigationBar];
                if (!CGRectIsNull(fakeBarFrame)) {
                    UIToolbar *fakeBar = self.fromViewControllerFakeBar;
                    [fakeBar applyNavigationBarConfiguration:currentConfigure];
                    fakeBar.frame = fakeBarFrame;
                    [fromVC.view addSubview:fakeBar];
                }
            }
            
            if (toVC && [showConfigure isVisible]) {
                CGRect fakeBarFrame = [toVC fakeBarFrameForNavigationBar:navigationBar];
                if (!CGRectIsNull(fakeBarFrame)) {
                    if (toVC.extendedLayoutIncludesOpaqueBars || showConfigure.translucent) {
                        fakeBarFrame.origin.y = toVC.view.bounds.origin.y;
                    }
                    
                    UIToolbar *fakeBar = self.toViewControllerFakeBar;
                    [fakeBar applyNavigationBarConfiguration:showConfigure];
                    fakeBar.frame = fakeBarFrame;
                    [toVC.view addSubview:fakeBar];
                }
            }
            
            [toVC.view addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(bounds))
                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           context:boundsContext];
            
            [UIView setAnimationsEnabled:YES];
        }
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([context isCancelled]) {
            [self removeFakeBars];
            [navigationBar applyBarConfiguration:currentConfigure];
            
            if (currentConfigure.hidden != navigationController.navigationBarHidden) {
                [navigationController setNavigationBarHidden:showConfigure.hidden animated:animated];
            }
        }
        
        if (showFakeBar) {
            UIViewController *const toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            [toVC.view removeObserver:self
                           forKeyPath:NSStringFromSelector(@selector(bounds))
                              context:boundsContext];
        }
        
        if (self) {
            self.isTransitionNavigationBar = NO;
        }
    }];
    
    void (^popunteractionEndBlock) (id<UIViewControllerTransitionCoordinatorContext>) = ^(id<UIViewControllerTransitionCoordinatorContext> content) {
        if ([content isCancelled]) {
            [navigationBar adjustWithBarStyle:currentConfigure.barStyle
                                    tintColor:currentConfigure.tintColor
                              titleAttributes:currentConfigure.titleAttributes];
    
            viewController.currentBarConfigure = currentConfigure;
            [viewController setNeedsStatusBarAppearanceUpdate];
            
        }
    };
    
    if (@available(iOS 10,*)) {
        [navigationController.transitionCoordinator notifyWhenInteractionChangesUsingBlock:popunteractionEndBlock];
    } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [navigationController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:popunteractionEndBlock];
#pragma GCC diagnostic pop
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self removeFakeBars];
    
    SPNavigationBarConfiguration *showConfigure = self.defaultBarConfigure;
    
    if ([viewController hasCustomNavigationBarStyle]) {
        id<SPNavigationBarProtocol> owner = (id<SPNavigationBarProtocol>)viewController;
        showConfigure = [[SPNavigationBarConfiguration alloc] initWithBarConfigurationOwner:owner];
    }
    
    UINavigationBar *const navigationBar = navigationController.navigationBar;
    navigationBar.barStyle = showConfigure.statusBarStyle == UIStatusBarStyleLightContent?UIBarStyleBlack:UIBarStyleDefault;
    [navigationBar applyBarConfiguration:showConfigure];
    
    viewController.currentBarConfigure = showConfigure;
    [viewController setNeedsStatusBarAppearanceUpdate];
    
    _isTransitionNavigationBar = NO;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == boundsContext) {
        UIView *view = (UIView *)object;
        UIToolbar *fakeBar = self.toViewControllerFakeBar;
        
        if (fakeBar.superview == view) {
            CGRect fakeBarFrame = fakeBar.frame;
            
            CGRect old = [change[NSKeyValueChangeOldKey] CGRectValue];
            CGRect new = [change[NSKeyValueChangeNewKey] CGRectValue];
            CGFloat offset = new.origin.y - old.origin.y;
            if (offset != 0) {
                fakeBarFrame.origin.y += offset;
                fakeBar.frame = fakeBarFrame;
            }
        }
    }
}

#pragma mark - Getters
- (UIToolbar *)fromViewControllerFakeBar {
    if (!_fromViewControllerFakeBar) {
        _fromViewControllerFakeBar = [[UIToolbar alloc] init];
        _fromViewControllerFakeBar.delegate = self;
    }
    
    return _fromViewControllerFakeBar;
}

- (UIToolbar *)toViewControllerFakeBar {
    if (!_toViewControllerFakeBar) {
        _toViewControllerFakeBar = [[UIToolbar alloc] init];
        _toViewControllerFakeBar.delegate = self;
    }
    
    return _toViewControllerFakeBar;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTop;
}

- (void)removeFakeBars {
    [_fromViewControllerFakeBar removeFromSuperview];
    [_toViewControllerFakeBar removeFromSuperview];
}

static inline BOOL transitionNeedShowFakeBar(SPNavigationBarConfiguration *from, SPNavigationBarConfiguration *to) {
    
    BOOL showFakeBar = NO;
    
    do {
        if (from.hidden || to.hidden)  {
            break;
        }
        
        if (from.transparent != to.transparent ||
            from.translucent != to.translucent) {
            showFakeBar = YES;
            break;
        }
        
        if (from.useSystemBarBackground && to.useSystemBarBackground) {
            showFakeBar = from.statusBarStyle != to.statusBarStyle;
        } else if (from.backgroundImage && to.backgroundImage) {
            NSString * const fromImageName = from.backgroundImageIdentifier;
            NSString * const toImageName = to.backgroundImageIdentifier;
            
            if (fromImageName && toImageName) {
                showFakeBar = ![fromImageName isEqualToString:toImageName];
                break;
            }
            
            NSData *const fromImageData = UIImagePNGRepresentation(from.backgroundImage);
            NSData *const toImageData = UIImagePNGRepresentation(to.backgroundImage);
            
            if ([fromImageData isEqualToData:toImageData]) {
                break;
            }
            
            showFakeBar = YES;
        } else if (![from.backgroundColor isEqual:to.backgroundColor]) {
            showFakeBar = YES;
        }
        
    } while (0);
    
    return showFakeBar;
}
@end
