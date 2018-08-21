//
//  SPNavigationControllerDelegateProxy.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/28.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPNavigationController;
@protocol UINavigationControllerDelegate;

@interface SPNavigationControllerDelegateProxy : NSProxy

- (instancetype) initWithNavigationTarget:(nullable id<UINavigationControllerDelegate>)navigationTarget
                              interceptor:(SPNavigationController *)interceptor;
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end
