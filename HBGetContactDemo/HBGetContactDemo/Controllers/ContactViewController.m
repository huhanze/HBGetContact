//
//  ContactViewController.m
//  HBGetContactDemo
//
//  Created by 胡海波 on 15/10/12.
//  Copyright © 2015年 Dylan.Hu. All rights reserved.
//

#import "ContactViewController.h"
#import "HBGetContact.h"

@interface ContactViewController ()

@property (nonatomic,strong) NSArray *contacts; // 联系人

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"联系人列表";
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reusedId = @"contact_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusedId];
    }
    
    NSDictionary *dict = self.contacts[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    cell.detailTextLabel.text = dict[@"telephoneNum"];

    
    return cell;
}

#pragma mark --- 懒加载
- (NSArray *)contacts {
    if (_contacts == nil) {
        _contacts = [HBGetContact getAllcontactsOfPhone].copy;
    }
    return _contacts;
}
@end
