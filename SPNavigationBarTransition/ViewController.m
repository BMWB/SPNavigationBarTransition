//
//  ViewController.m
//  SPNavigationBarTransition
//
//  Created by wtj on 2018/7/26.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+SPConfigure.h"
#import "SPDemoViewController.h"
#import "SPTransparentViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<NSDictionary *> * colors;
@property (strong, nonatomic) NSArray * images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    
    self.tableView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:view];
        
        view.delegate = self;
        view.dataSource = self;
        
        [view registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SPNavigationIdentifier"];
        
        view;
    });
    
    _colors = @[
                @{@"clear" : [UIColor clearColor]},
                @{@"Black" : [UIColor blackColor]},
                @{@"White" : [UIColor whiteColor]},
                @{@"TableView Background Color" : _tableView.backgroundColor},
                @{@"Red" : [UIColor redColor]}
                ];
    
    _images = @[@"green",
                @"blue",
                @"purple",
                @"red",
                @"yellow"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
       return self.colors.count;
    }
    if (section == 1) {
        return self.images.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPNavigationIdentifier" forIndexPath:indexPath];
        
        NSDictionary *color = self.colors[indexPath.row];
        cell.textLabel.text = color.allKeys.firstObject;
        cell.imageView.image = [UIImage imageWithColor:color.allValues.firstObject size:CGSizeMake(32, 32)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPNavigationIdentifier"];
        
        cell.textLabel.text = _images[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_images[indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPNavigationIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = @"Dynamic Gradient Bar";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Colors";
    }
    
    if (section == 1) {
       return @"images";
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"选择偏白的颜色的时候，关闭 Black Bar Style 展示效果更好";
    }
    
    if (section == 1) {
      return @"选择图片为背景的时候建议关掉半透明效果";
    }
     
    return @"style 根据页面滑动距离动态改变";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSDictionary *color = self.colors[indexPath.row];
        SPDemoViewController *v = [SPDemoViewController new];
        v.color = color.allValues.firstObject;
        [self.navigationController pushViewController:v animated:YES];
  
    }
    
    if (indexPath.section == 1) {
        SPDemoViewController *v = [SPDemoViewController new];
        v.imageName = _images[indexPath.row];
        v.image = [UIImage imageNamed:_images[indexPath.row]];
        [self.navigationController pushViewController:v animated:YES];
        
    }
    
    SPTransparentViewController *v = [SPTransparentViewController new];
    [self.navigationController pushViewController:v animated:YES];
   
}
@end
