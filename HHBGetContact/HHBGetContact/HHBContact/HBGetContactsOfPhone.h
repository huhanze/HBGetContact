//
//  HBGetContactsOfPhone.h
//  HHBGetContact
//  获取通讯录联系人
//  Created by DylanHu on 2018/1/16.
//  Copyright © 2018年 DylanHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNContact;
@interface HBGetContactsOfPhone : NSObject

+ (NSArray <CNContact *> *)getContactsFromContactLibrary;

@end
