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
#import "HHBGetContactsOfPhone.h"
#import "HHBGetContactsModel.h"
#import "UIView+HHBExtension.h"
#import "HHBTest02TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [[UIButton alloc] init];
    [self.view addSubview:btn1];
    [btn1 setTitle:@"获取通讯录1(通过AddressBook.Framework)" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor blackColor];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn1 sizeToFit];
    btn1.hb_centerX = self.view.hb_centerX;
    btn1.hb_centerY = self.view.hb_centerY - 50;
    btn1.hb_width += 20;
    
    if (@available(iOS 9.0,*)) {
        UIButton *btn2 = [[UIButton alloc] init];
        [self.view addSubview:btn2];
        [btn2 setTitle:@"获取通讯录2(通过Contacts.Framework)" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btn2TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        btn2.backgroundColor = [UIColor blackColor];
        btn2.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [btn2 sizeToFit];
        btn2.hb_centerX = self.view.hb_centerX;
        btn2.hb_centerY = self.view.hb_centerY + 50;
        btn2.hb_width += 20;
    }
}

#pragma mark - 获取通讯录
- (void)btn1TouchUpInside:(UIButton *)sender {
    HHBContactTableViewController *contactVC = [[HHBContactTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (void)btn2TouchUpInside:(UIButton *)sender {
    if (@available(iOS 9_0, *)) {
        HHBTest02TableViewController *contactVC = [[HHBTest02TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:contactVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
