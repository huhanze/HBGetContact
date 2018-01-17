//
//  HHBContactTableViewCell.m
//  HHBGetContact
//
//  Created by DylanHu on 2017/10/08.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import "HHBContactTableViewCell.h"
#import "HHBContactModel.h"
#import "HHBGetContactsModel.h"

@implementation HHBContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContact:(HHBContactModel *)contact {
    _contact = contact;
    self.textLabel.text = contact.name;
    self.detailTextLabel.text = contact.telephoneNum;
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
}

- (void)setContactModel:(HHBGetContactsModel *)contactModel {
    _contactModel = contactModel;
    self.textLabel.text = contactModel.fullName;
    self.detailTextLabel.text = contactModel.telephoneNum;
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
