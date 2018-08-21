//
//  SPNavigationBarConfiguration.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "SPNavigationBarConfiguration.h"

@implementation SPNavigationBarConfiguration

- (instancetype)init {
    
    return [self initWithBarBackgroundStyle:SPNavigationBarBackgroundStyleOpaque
                                  tintColor:nil
                            backgroundColor:nil
                            backgroundImage:nil
                  backgroundImageIdentifier:nil
                                   barStyle:UIStatusBarStyleLightContent
                                  barHidden:NO
                            titleAttributes:[[UINavigationBar appearance] titleTextAttributes]];
}

- (instancetype)initWithBarBackgroundStyle:(SPNavigationBarBackgroundStyle)style
                                 tintColor:(UIColor *)tintColor
                           backgroundColor:(UIColor *)backgroundColor
                           backgroundImage:(UIImage *)backgroundImage
                 backgroundImageIdentifier:(NSString *)backgroundImageIdentifier
                                  barStyle:(UIStatusBarStyle)barStyle
                                 barHidden:(BOOL)barHidden
                           titleAttributes:(NSDictionary<NSAttributedStringKey,id> *)titleAttributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    do {
        
        _hidden = barHidden;
        _statusBarStyle = barStyle;
        _barStyle =  _statusBarStyle == UIStatusBarStyleLightContent ? UIBarStyleBlack:UIBarStyleDefault;
        
        if (!tintColor) {
            tintColor = _statusBarStyle == UIStatusBarStyleLightContent ? [UIColor whiteColor]:[UIColor blackColor];
        }
        
        _tintColor = tintColor;
        
        if (_hidden) {
            break;
        }
        
        _transparent = (style == SPNavigationBarBackgroundStyleTransparent);
        
        if (_transparent) {
            break;
        }
        
        _translucent = (style == SPNavigationBarBackgroundStyleTranslucent);
        
        if (backgroundImage) {
            _backgroundImage = backgroundImage;
            _backgroundImageIdentifier = [backgroundImageIdentifier copy];
        } else if (backgroundColor) {
            _backgroundColor = backgroundColor;
        }
        
        _titleAttributes = titleAttributes;
        
        
    } while (0);
    
    return self;
}
@end

@implementation SPNavigationBarConfiguration (SPBarTransition)

- (instancetype)Default {
    UIColor *tintColor = [UINavigationBar appearance].tintColor;
    UIColor *backgroundColor = [UINavigationBar appearance].barTintColor;
    NSDictionary<NSAttributedStringKey, id> * titleAttributed = [[UINavigationBar appearance] titleTextAttributes];
    
    return [self initWithBarBackgroundStyle:SPNavigationBarBackgroundStyleOpaque
                                  tintColor:tintColor
                            backgroundColor:backgroundColor
                            backgroundImage:nil
                  backgroundImageIdentifier:nil
                                   barStyle:UIStatusBarStyleLightContent
                                  barHidden:NO
                            titleAttributes:titleAttributed];
}

- (instancetype)initWithBarConfigurationOwner:(id<SPNavigationBarProtocol>)owner {
    
    SPNavigationBarBackgroundStyle style = SPNavigationBarBackgroundStyleOpaque;
    UIColor *tintColor = nil;
    NSString *imageIdentifier = nil;
    UIImage *backgroundImage = nil;
    UIColor *backgroundColor = nil;
    UIStatusBarStyle barStyle = UIStatusBarStyleLightContent;
    BOOL barHidden = NO;
    NSDictionary<NSAttributedStringKey, id> * titleAttributed = nil;
    
    if ([owner respondsToSelector:@selector(navigationBarTintColor)]) {
        tintColor = [owner navigationBarTintColor];
    } else {
        tintColor = [UINavigationBar appearance].tintColor;
    }
    
    if ([owner respondsToSelector:@selector(navigationStatusBarStyle)]) {
        barStyle = [owner navigationStatusBarStyle];
    }
    
    if ([owner respondsToSelector:@selector(navigationBarHidden)]) {
        barHidden = [owner navigationBarHidden];
    }
    
    if ([owner respondsToSelector:@selector(navigationBarBackgroundStyle)]) {
        style = [owner navigationBarBackgroundStyle];
    }
    
    if (!(style == SPNavigationBarBackgroundStyleTransparent)) {
        NSDictionary *backgroundImageDict  = nil;
        
        if ([owner respondsToSelector:@selector(navigationBackgroundImage)]) {
            backgroundImageDict = [owner navigationBackgroundImage];
        }
        
        if (!!backgroundImageDict
            && [backgroundImageDict.allKeys.firstObject isKindOfClass:[NSString class]]
            && [backgroundImageDict.allValues.firstObject isKindOfClass:[UIImage class]]) {
            imageIdentifier = backgroundImageDict.allKeys.firstObject;
            backgroundImage = backgroundImageDict.allValues.firstObject;
        } else if ([owner respondsToSelector:@selector(navigationBackgroundColor)]) {
            backgroundColor = [owner navigationBackgroundColor];
        } else {
            backgroundColor = [UINavigationBar appearance].barTintColor;
        }
    }
    
    if ([owner respondsToSelector:@selector(navigationTitleTextAttributes)]) {
        titleAttributed = [owner navigationTitleTextAttributes];
    } else {
        titleAttributed = [[UINavigationBar appearance] titleTextAttributes];
    }
    
    return [self initWithBarBackgroundStyle:style
                                  tintColor:tintColor
                            backgroundColor:backgroundColor
                            backgroundImage:backgroundImage
                  backgroundImageIdentifier:imageIdentifier
                                   barStyle:barStyle
                                  barHidden:barHidden
                            titleAttributes:titleAttributed];
}

- (BOOL)isVisible {
    return !self.hidden && !self.transparent;
}

- (BOOL)useSystemBarBackground {
    return !self.backgroundColor && !self.backgroundImage;
}
@end
