//
//  HBGetContactsModel.m
//  HBGetContactsModel
//  联系人模型 
//  Created by DylanHu on 2018/1/16.
//  Copyright © 2018年 DylanHu. All rights reserved.
//
#import "HHBGetContactsModel.h"
#import <Contacts/CNContact.h>
#import <Contacts/CNContactFormatter.h>
#import "HHBGetContactsOfPhone.h"
#import "HHBFirstLetter.h"

@implementation HHBGetContactsModel

- (instancetype)initWithCNContact:(CNContact *)contact {
    if (self = [super init]) {
        NSString *firstName = contact.givenName;
        NSString *lastName = contact.familyName;
        NSString *fullName = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        if (!fullName.length) {
            if (firstName.length || lastName.length) {
                fullName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
            }
        }
        _fullName = fullName;
        // 解析手机号、可能有多个
        for (CNLabeledValue *phoneValue in contact.phoneNumbers) {
            CNPhoneNumber *phoneNum = (CNPhoneNumber *)phoneValue.value;
            _telephoneNum = phoneNum.stringValue;
        }
        // 解析邮箱地址
        for (CNLabeledValue *emailAdress in contact.emailAddresses) {
            NSString *email = (NSString *)emailAdress.value;
            _email = email;
            if (!fullName.length) {
                _fullName = email;
            }
        }
        _index = fullName.length ? [NSString stringWithFormat:@"%c",getFirstLetter([fullName characterAtIndex:0])].uppercaseString : @"#";
    }
    return self;
}

+ (instancetype)contactsModelWithCNContact:(CNContact *)contact {
    return [[self alloc] initWithCNContact:contact];
}


+ (NSArray <HHBGetContactsModel *> *)contactModelsWithArray:(NSArray <CNContact *> *)contacts {
    NSMutableArray *contactsModelM = nil;
    if (contacts.count) {
        contactsModelM = [NSMutableArray arrayWithCapacity:contacts.count];
        for (CNContact *contact in contacts) {
            HHBGetContactsModel *contactModel = [self contactsModelWithCNContact:contact];
            [contactsModelM addObject:contactModel];
        }
    }
    return contactsModelM.copy;
}

+ (NSArray <HHBGetContactsModel *> *)getContacts {
    return [self contactModelsWithArray:[HHBGetContactsOfPhone getContactsFromContactLibrary]];
}

@end

// ------------------------------------------------------------------
@interface HHBGetContactsCategoryModel()

/// 索引
@property (nonatomic, copy) NSString *index;

/// 索引对应的联系人集合
@property (nonatomic, copy) NSArray <HHBGetContactsModel *> *contactsArray;

@end

@implementation HHBGetContactsCategoryModel


#pragma mark - 获取当前设备排序分类后的数据模型集合
+ (NSArray <HHBGetContactsCategoryModel *> *)getContactsCategoryModel {
    NSArray *dataArray = [HHBGetContactsModel getContacts];
    NSMutableDictionary *dict = @{}.mutableCopy;
    NSMutableArray *indexArray = @[].mutableCopy;
    NSMutableArray *modelArray = @[].mutableCopy;
    for (HHBGetContactsModel *model in dataArray) {
        if ([indexArray containsObject:model.index]) {
            NSMutableArray *tempArray = [[dict objectForKey:model.index] mutableCopy];
            [tempArray addObject:model];
            [dict setValue:tempArray.copy forKey:model.index];
        } else {
            [indexArray addObject:model.index];
            [dict setValue:@[model] forKey:model.index];
        }
    }
    
    // 字母索引按升序排序
    [indexArray sortUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    // 如果有 “#” 数据则插入到最后
    if ([indexArray.firstObject isEqualToString:@"#"]) {
        [indexArray removeObjectAtIndex:0];
        [indexArray addObject:@"#"];
    }
    
    // 组装成最终数据模型
    for (NSString *index in indexArray) {
        HHBGetContactsCategoryModel *categoryModel = [[HHBGetContactsCategoryModel alloc] init];
        categoryModel.index = index;
        NSMutableArray *contactsArray = [[dict objectForKey:index] mutableCopy];
        categoryModel.contactsArray = contactsArray.copy;
        [modelArray addObject:categoryModel];
    }
    
    return modelArray.copy;
}

@end


