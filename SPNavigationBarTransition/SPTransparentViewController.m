//
//  SPTransparentViewController.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/31.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "SPTransparentViewController.h"
#import "ViewController.h"
#import "UIViewController+SPNavigationBarTransition.h"

@interface SPTransparentViewController ()<UITableViewDelegate>
@property (nonatomic, strong) ViewController *configureController;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headerView;
@end

@implementation SPTransparentViewController
{
    CGFloat _gradientProgress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Dynamic Gradient Bar";
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor clearColor];
    _titleLabel.text = self.title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    _configureController = [ViewController new];
    [self addChildViewController:_configureController];
    
    UIView *confView = _configureController.view;
    confView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    confView.frame = self.view.bounds;
    [self.view addSubview:confView];
    [_configureController didMoveToParentViewController:self];
    
    UITableView *tableView = _configureController.tableView;
    tableView.delegate = self;
    
    if (@available(iOS 11,*)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"lakeside_sunset" ofType:@"png"];
    UIImage *headerImage = [UIImage imageWithContentsOfFile:imagePath];
    _headerView = [[UIImageView alloc] initWithImage:headerImage];
    _headerView.clipsToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_headerView aboveSubview:tableView];
    
    UIBarButtonItem *popToRoot = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                               target:self
                                                                               action:@selector(popToRoot:)];
    self.navigationItem.rightBarButtonItem = popToRoot;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UITableView *tableView = self.configureController.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    CGRect headerFrame = headerView.frame;
    
    if (tableView.contentInset.top == 0) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        if (@available(iOS 11,*)) {
            inset.bottom = self.view.safeAreaInsets.bottom;
        }
        tableView.scrollIndicatorInsets = inset;
        inset.top = imageHeight;
        tableView.contentInset = inset;
        
        tableView.contentOffset = CGPointMake(0, -inset.top);
    }
    
    if (CGRectGetHeight(headerFrame) != imageHeight) {
        headerView.frame = [self headerImageFrame];
    }
}

- (CGRect)headerImageFrame {
    UITableView *tableView = self.configureController.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    
    CGFloat contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    if (contentOffsetY < 0) {
        imageHeight += -contentOffsetY;
    }
    
    CGRect headerFrame = self.view.bounds;
    if (contentOffsetY > 0) {
        headerFrame.origin.y -= contentOffsetY;
    }
    headerFrame.size.height = imageHeight;
    
    return headerFrame;
}

- (void)popToRoot:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<UITableViewDelegate> delegate = (id<UITableViewDelegate>)self.configureController;
    return [delegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<UITableViewDelegate> delegate = (id<UITableViewDelegate>)self.configureController;
    [delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = CGRectGetHeight(self.headerView.frame);
    if (@available(iOS 11,*)) {
        headerHeight -= self.view.safeAreaInsets.top;
    } else {
        headerHeight -= [self.topLayoutGuide length];
    }
    
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        self.titleLabel.textColor = _gradientProgress == 1 ? [self navigationBarTintColor] : [UIColor clearColor];
        [self refreshNavigationBarStyle];
    }
    
    self.headerView.frame = [self headerImageFrame];
}

#pragma mark -

- (SPNavigationBarBackgroundStyle)navigationBarBackgroundStyle {
    SPNavigationBarBackgroundStyle configurations = SPNavigationBarBackgroundStyleTransparent;

    if (_gradientProgress < 1) {
        configurations = SPNavigationBarBackgroundStyleTranslucent;
    }
    
    if (_gradientProgress == 1) {
        configurations = SPNavigationBarBackgroundStyleOpaque;
    }
    
    return configurations;
}

- (UIColor *)navigationBarTintColor {
    return [UIColor colorWithWhite:1 - _gradientProgress alpha:1];
}

- (UIColor *)navigationBackgroundColor {
    return [UIColor colorWithWhite:1 alpha:_gradientProgress];
}


@end
