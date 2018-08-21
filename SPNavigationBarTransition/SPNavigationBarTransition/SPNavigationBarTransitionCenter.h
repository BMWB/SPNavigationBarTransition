//
//  SPNavigationBarTransitionCenter.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPNavigationBarProtocol.h"

@interface SPNavigationBarTransitionCenter : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithDefaultBarConfiguration:(id<SPNavigationBarProtocol>)_default NS_DESIGNATED_INITIALIZER;

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
