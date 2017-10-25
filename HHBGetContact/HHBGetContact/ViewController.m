//
//  ViewController.m
//  HHBGetContact
//
//  Created by DylanHu on 2017/10/08.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import "ViewController.h"
#import "HHBContactTableViewController.h"
#import "HHBGetContact.h"
#import "UIView+HHBExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
    [self.view addSubview:btn];
    [btn setTitle:@"获取通讯录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor blackColor];
    btn.hb_centerX = self.view.hb_centerX;
    btn.hb_centerY = self.view.hb_centerY;
}

- (void)btnTouchUpInside:(UIButton *)sender {
    HHBContactTableViewController *contactVC = [[HHBContactTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
