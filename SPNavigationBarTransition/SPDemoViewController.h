//
//  SPDemoViewController.h
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/30.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPNavigationBarProtocol.h"

@interface SPDemoViewController : UIViewController<SPNavigationBarProtocol>

@property (strong, nonatomic) UIColor * color;
@property (strong, nonatomic) NSString * imageName;
@property (strong, nonatomic) UIImage * image;

@end
