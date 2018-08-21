//
//  UIToolbar+SPConfigure.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "UIToolbar+SPConfigure.h"
#import "SPNavigationBarConfiguration.h"
#import "UIImage+SPConfigure.h"

@implementation UIToolbar (SPConfigure)

- (void)applyNavigationBarConfiguration:(SPNavigationBarConfiguration *)configure {
    UIImage * const transpanrentImage = [UIImage transparentImage];
    
    if (configure.transparent) {
        self.translucent = YES;
        [self setBackgroundImage:transpanrentImage
              forToolbarPosition:UIBarPositionAny
                      barMetrics:UIBarMetricsDefault];
        
    } else {
        self.translucent = configure.translucent;
        
        UIImage *backgroundImage = configure.backgroundImage;
        
        if (!backgroundImage && configure.backgroundColor) {
            backgroundImage = [UIImage imageWithColor:configure.backgroundColor];
        }
        
        [self setBackgroundImage:backgroundImage
              forToolbarPosition:UIBarPositionAny
                      barMetrics:UIBarMetricsDefault];
    }
    
    [self setShadowImage:transpanrentImage
      forToolbarPosition:UIBarPositionAny];
}
@end
