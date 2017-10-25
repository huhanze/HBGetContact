//
//  HHBContactTableViewController.m
//  HHBGetContact
//
//  Created by DylanHu on 2017/10/08.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import "HHBContactTableViewController.h"
#import "HHBContactTableViewCell.h"
#import "UIColor+HHBColorExtension.h"

@interface HHBContactTableViewController ()

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSArray *indexArray;
@property (nonatomic, strong) UILabel *sectionTitleLabel;

@end

@implementation HHBContactTableViewController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [HHBContactCategoryModel getContactsCategoryModel];
    }
    return _dataArray;
}

-(NSArray *)indexArray {
    if (!_indexArray) {
        NSMutableArray *array = @[].mutableCopy;
        for (HHBContactCategoryModel *model in self.dataArray) {
            [array addObject:model.index];
        }
        _indexArray = array.copy;
    }
    return _indexArray;
}

- (void)dealloc {
    [_sectionTitleLabel removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor hb_colorFromHexRGB:@"f7f7f7"];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HHBContactCategoryModel *model = self.dataArray[section];
    return model.contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHBContactCategoryModel *model = self.dataArray[indexPath.section];
    HHBContactModel *contactModel = model.contactsArray[indexPath.row];
    HHBContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        cell = [[HHBContactTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    }
    cell.contact = contactModel;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexArray[section];
}

#pragma mark -Section的Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return 40;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count - 1) {
        return 40;
    }
    return 20;
}

#pragma mark - Section header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHBContactCategoryModel *model = self.dataArray[section];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.hb_width - 20, 20)];
    lab.backgroundColor = self.tableView.backgroundColor;
    NSString *headerStr = [NSString stringWithFormat:@"   %@",model.index];
    lab.text = headerStr;
    lab.textColor = [UIColor hb_colorFromHexRGB:@"222222"];
    return lab;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.hb_width - 20, 20)];
    view.backgroundColor = self.tableView.backgroundColor;
    return view;
}

#pragma mark -设置右方表格的索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

#pragma mark - 选择索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    self.sectionTitleLabel.text = title;
    self.sectionTitleLabel.alpha = 1;
    [self performSelector:@selector(hideTitleView) withObject:nil afterDelay:1];
    return index;
}

#pragma mark - UITableViewDelegate方法

- (void)hideTitleView {
    [UIView animateWithDuration:1.5 animations:^{
        self.sectionTitleLabel.alpha = 0;
    }];
}

- (UILabel *)sectionTitleLabel {
    if (_sectionTitleLabel) {
        return _sectionTitleLabel;
    }
    _sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _sectionTitleLabel.center = self.view.center;
    _sectionTitleLabel.backgroundColor = [UIColor hb_colorFromHexRGB:@"222222"];
    _sectionTitleLabel.layer.cornerRadius = 5;
    _sectionTitleLabel.layer.masksToBounds = YES;
    _sectionTitleLabel.alpha = 0.8;
    _sectionTitleLabel.font = [UIFont systemFontOfSize:75];
    _sectionTitleLabel.textAlignment = NSTextAlignmentCenter;
    _sectionTitleLabel.textColor = [UIColor hb_colorFromHexRGB:@"f6f6f6"];
    [[UIApplication sharedApplication].keyWindow addSubview:_sectionTitleLabel];
    return _sectionTitleLabel;
}


@end
