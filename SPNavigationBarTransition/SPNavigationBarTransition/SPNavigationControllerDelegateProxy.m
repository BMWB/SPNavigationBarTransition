//
//  SPNavigationControllerDelegateProxy.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/28.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "SPNavigationControllerDelegateProxy.h"
#import "SPNavigationController.h"

static inline BOOL isInterceptedSelector(SEL sel);

@interface SPNavigationControllerDelegateProxy()

@property (weak,   nonatomic) id navigationTarget;
@property (weak,   nonatomic) SPNavigationController * interceptor;

@end

@implementation SPNavigationControllerDelegateProxy

- (instancetype)initWithNavigationTarget:(id<UINavigationControllerDelegate>)navigationTarget
                             interceptor:(SPNavigationController *)interceptor {
    
    if (self) {
        _navigationTarget = navigationTarget;
        _interceptor = interceptor;
    }
    
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return isInterceptedSelector(aSelector) || [_navigationTarget respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return  isInterceptedSelector(aSelector) ? _interceptor : _navigationTarget;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

static inline BOOL isInterceptedSelector(SEL sel) {
    return (sel == @selector(navigationController:willShowViewController:animated:) ||
            sel == @selector(navigationController:didShowViewController:animated:));
}

@end
