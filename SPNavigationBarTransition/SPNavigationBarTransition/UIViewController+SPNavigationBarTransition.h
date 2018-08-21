//
//  UIViewController+SPNavigationBarTransition.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPNavigationBarConfiguration;

@interface UIViewController (SPNavigationBarTransition)

@property (nonatomic, strong) SPNavigationBarConfiguration * currentBarConfigure;

- (BOOL)hasCustomNavigationBarStyle;
- (void)refreshNavigationBarStyle;
- (CGRect)fakeBarFrameForNavigationBar:(UINavigationBar *)navigationBar;

@end
