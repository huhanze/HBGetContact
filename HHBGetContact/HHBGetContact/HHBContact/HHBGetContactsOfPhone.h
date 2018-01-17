//
//  HBGetContactsOfPhone.h
//  HHBGetContact
//  获取通讯录联系人
//  Created by DylanHu on 2018/1/16.
//  Copyright © 2018年 DylanHu. All rights reserved.
//
/*
 本人写的这个例子是纯数据处理库， 若自定义UI的话，本例子可以仅作为参考。
 另外，苹果提供了ContactsUI.Framework,  如果使用iPhone系统通讯录样式直接调用该UI库即可，关于调用方式不难，这里略过......
 */

#import <Foundation/Foundation.h>

@class CNContact;

NS_CLASS_AVAILABLE_IOS(9_0)
@interface HHBGetContactsOfPhone : NSObject


/**
 获取联系人信息

 @return 联系人数据集合
 */
+ (NSArray <CNContact *> *)getContactsFromContactLibrary;

@end
