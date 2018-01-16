//
//  HBGetContactsOfPhone.m
//  HHBGetContact
//  获取通讯录联系人
//  iOS9.0以后，苹果推出了一套新的获取通讯录联系人API,
//  此API主要以OC编写的一套，更加的面相对象，对于那些不是非常熟悉C的开发者来说，使用起来简单、直接，
//  而且相对于AddressBook.Framework框架优化了很多，如果不对iOS9.0以下的设备适配，推荐该方式

//  Created by DylanHu on 2018/1/16.
//  Copyright © 2018年 DylanHu. All rights reserved.
//

#import "HBGetContactsOfPhone.h"
#import <Contacts/Contacts.h>

@implementation HBGetContactsOfPhone

#pragma mark - 通过CNContact方式获取信息，iOS9.0以后可以通过此方式
+ (NSArray <CNContact *> *)getContactsFromContactLibrary {
    NSMutableArray *contactM = nil;
    if (@available(iOS 9.0, *)) {
        contactM = @[].mutableCopy;
        CNContactStore *store = [[CNContactStore alloc] init];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactFamilyNameKey,CNContactNamePrefixKey,CNContactGivenNameKey,CNContactMiddleNameKey,CNContactPhoneNumbersKey]];
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusAuthorized) {
            [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                [contactM addObject:contact];
            }];
        }
    } else {
        
    }
    return contactM.copy;
}

@end
