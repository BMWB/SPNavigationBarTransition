//
//  UIToolbar+SPConfigure.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPNavigationBarConfiguration;

@interface UIToolbar (SPConfigure)

- (void)applyNavigationBarConfiguration:(SPNavigationBarConfiguration *)configure;
@end
