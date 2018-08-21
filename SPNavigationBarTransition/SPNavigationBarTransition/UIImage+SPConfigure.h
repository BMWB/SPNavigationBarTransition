//
//  UIImage+SPConfigure.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SPConfigure)

+ (UIImage *)transparentImage;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize) size;

@end
