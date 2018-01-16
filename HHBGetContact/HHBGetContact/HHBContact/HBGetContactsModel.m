//
//  HBGetContactsModel.m
//  HHBGetContact
//  联系人模型 
//  Created by DylanHu on 2018/1/16.
//  Copyright © 2018年 DylanHu. All rights reserved.
//

#import "HBGetContactsModel.h"
#import <Contacts/CNContact.h>

@implementation HBGetContactsModel

- (instancetype)initWithCNContact:(CNContact *)contact {
    if (self = [super init]) {
        NSString *fullName = contact.familyName;
        if (contact.familyName.length && contact.givenName.length) {
            fullName = [NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName];
        } else if (!contact.familyName.length && contact.givenName.length) {
            fullName = contact.givenName;
        }
        _fullName = fullName;
        for (CNLabeledValue *phoneValue in contact.phoneNumbers) {
            CNPhoneNumber *phoneNum = (CNPhoneNumber *)phoneValue.value;
            _telephoneNum = phoneNum.stringValue;
        }
    }
    return self;
}

+ (instancetype)contactsModelWithCNContact:(CNContact *)contact {
    return [[self alloc] initWithCNContact:contact];
}


+ (NSArray <HBGetContactsModel *> *)contactModelsWithArray:(NSArray <CNContact *> *)contacts {
    for (CNContact *contact in contacts) {
        [self contactsModelWithCNContact:contact];
    }
    return nil;
}

@end
