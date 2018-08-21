//
//  SPNavigationBarConfiguration.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPNavigationBarProtocol.h"

@interface SPNavigationBarConfiguration : NSObject

@property (nonatomic, assign, readonly) BOOL hidden;
@property (nonatomic, assign, readonly) UIBarStyle barStyle;
@property (nonatomic, assign, readonly) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign, readonly) BOOL translucent;//半透明
@property (nonatomic, assign, readonly) BOOL transparent;//透明
@property (nonatomic, strong, readonly) UIColor *tintColor;//默认 whiteColor
@property (nonatomic, strong, readonly, nullable) UIColor *backgroundColor;
@property (nonatomic, strong, readonly, nullable) UIImage *backgroundImage;
@property (nonatomic, strong, readonly, nullable) NSString *backgroundImageIdentifier;
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *titleAttributes;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithBarBackgroundStyle:(SPNavigationBarBackgroundStyle)style
                                 tintColor:(nullable UIColor*) tintColor
                           backgroundColor:(nullable UIColor *)backgroundColor
                           backgroundImage:(nullable UIImage *)backgroundImage
                 backgroundImageIdentifier:(nullable NSString*)backgroundImageIdentifier
                                  barStyle:(UIStatusBarStyle)barStyle
                                 barHidden:(BOOL)barHidden
                           titleAttributes:(NSDictionary<NSAttributedStringKey, id> *)titleAttributes NS_DESIGNATED_INITIALIZER;

@end

@interface SPNavigationBarConfiguration (SPBarTransition)

- (instancetype)Default;
- (instancetype)initWithBarConfigurationOwner:(id<SPNavigationBarProtocol>)owner;

- (BOOL)isVisible;

- (BOOL)useSystemBarBackground;

@end
