//
//  UINavigationBar+SPConfigure.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "UINavigationBar+SPConfigure.h"
#import <objc/runtime.h>
#import "SPNavigationBarConfiguration.h"
#import "UIImage+SPConfigure.h"

@implementation UINavigationBar (SPConfigure)

- (void)adjustWithBarStyle:(UIBarStyle)barStyle
                 tintColor:(UIColor *)tintColor
           titleAttributes:(NSDictionary<NSAttributedStringKey,id> *)titleAttributes {
    self.barStyle = barStyle;
    self.tintColor = tintColor;
    self.titleTextAttributes = titleAttributes;
}

- (UIView *)backgroundView {
    return [self valueForKey:@"_backgroundView"];
}

- (void)applyBarConfiguration:(SPNavigationBarConfiguration *)configure {
#if DEBUG
    if (@available(iOS 11,*)) {
        NSAssert(!self.prefersLargeTitles, @"large titles is not supported");
    }
#endif
    
    [self adjustWithBarStyle:configure.barStyle
                   tintColor:configure.tintColor
             titleAttributes:configure.titleAttributes];
    
    UIView *barBackgroundView = [self backgroundView];
    UIImage* const transpanrentImage = [UIImage transparentImage];
    if (configure.transparent) {
        if (barBackgroundView) {
            barBackgroundView.alpha = 0;
        }
        
        self.translucent = YES;
        [self setBackgroundImage:transpanrentImage forBarMetrics:UIBarMetricsDefault];
    } else {
        if (barBackgroundView) {
            barBackgroundView.alpha = 1;
        }
        self.translucent = configure.translucent;
        UIImage* backgroundImage = configure.backgroundImage;
        if (!backgroundImage && configure.backgroundColor) {
            backgroundImage = [UIImage imageWithColor:configure.backgroundColor];
        }
        
        [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    self.shadowImage = transpanrentImage;
    
    [self setCurrentBarConfigure:configure];
}

- (SPNavigationBarConfiguration *)currentBarConfigure {
    return objc_getAssociatedObject(self, @selector(currentBarConfigure));
}

- (void)setCurrentBarConfigure:(SPNavigationBarConfiguration *)currentBarConfigure {
    objc_setAssociatedObject(self, @selector(currentBarConfigure), currentBarConfigure, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
