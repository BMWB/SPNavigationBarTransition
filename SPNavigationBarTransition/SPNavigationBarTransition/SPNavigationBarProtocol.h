//
//  SPNavigationBarProtocol.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Translucent

 - SPNavigationBarBackgroundStyleTranslucent: 半透明
 - SPNavigationBarBackgroundStyleOpaque: 不透明
 - SPNavigationBarBackgroundStyleTransparent: 透明
 */
typedef NS_ENUM(NSUInteger, SPNavigationBarBackgroundStyle) {
    SPNavigationBarBackgroundStyleTranslucent = 0,
    SPNavigationBarBackgroundStyleOpaque      = 1,
    SPNavigationBarBackgroundStyleTransparent = 2,
};

@protocol SPNavigationBarProtocol <NSObject>

@optional

/**
 是否可以手动右滑
 
 @return BOOL
 */
- (BOOL)navigationDragBack;

/**
 BarBackgroundStyle
 
 @return SPNavigationBarBackgroundStyle
 */
- (SPNavigationBarBackgroundStyle)navigationBarBackgroundStyle;

/**
 UIStatusBarStyle
 
 @return UIStatusBarStyle
 */
- (UIStatusBarStyle)navigationStatusBarStyle;

/**
 隐藏导航栏
 
 @return BOOL
 */
- (BOOL)navigationBarHidden;

/**
 TintColor
 
 @return UIColor
 */
- (UIColor *)navigationBarTintColor;

/**
 BackgroundColor
 
 @return UIColor
 */
- (UIColor *)navigationBackgroundColor;

/**
 BackgroundImage
 
 @return  key:identifier 用来比较 image 是否是同
        value:image 设置这个后 navigationBackgroundColor不起作用
 */
- (NSDictionary<NSString *,UIImage *> *)navigationBackgroundImage;

/**
 TitleTextAttributes

 @return TitleTextAttributes
 */
- (NSDictionary<NSAttributedStringKey, id> *)navigationTitleTextAttributes;

@end
