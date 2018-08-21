//
//  UINavigationBar+SPConfigure.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPNavigationBarConfiguration;

@interface UINavigationBar (SPConfigure)

@property (nonatomic, strong, readonly) SPNavigationBarConfiguration * currentBarConfigure;

- (void)adjustWithBarStyle:(UIBarStyle)barStyle
                 tintColor:(UIColor *)tintColor
           titleAttributes:(NSDictionary<NSAttributedStringKey, id> *)titleAttributes;

- (void)applyBarConfiguration:(SPNavigationBarConfiguration *)configure;

- (UIView *)backgroundView;

@end
