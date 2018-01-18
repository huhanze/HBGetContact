//
//  HBGetContactsModel.h
//  HBGetContactsModel
//  联系人模型 --- 针对处理CNContact(iOS9.0以后)数据的处理
//  Created by DylanHu on 2018/1/16.
//  Copyright © 2018年 DylanHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNContact;

NS_CLASS_AVAILABLE_IOS(9_0)
/*
 当前模型针对iOS9.0以后，苹果推出的获取通讯录联系人的新库，该库相比之前的C语言API有很大优势。
 通过该API拿到的通讯录是基本已经排好序的，所以只获取姓名的首字符作为索引归类即可，不用再做排序处理，这样大大提高了效率。
 之前的库中文下需要通过中文的汉语拼音进行排序，而将中文汉字转换为汉语拼音这一过程很费时，效率明显降低。
 如果不对iOS9.0以下的设备做适配，推荐使用新API
 
 本人写的这个例子是纯数据处理库，苹果提供了ContactsUI.Framework,  如果使用iPhone系统通讯录样式直接调用该UI库即可，
 若自定义UI，本例子可以仅作为参考。
 */
@interface HHBGetContactsModel : NSObject

/*
 这里就用以下三个属性数据作为例子，其它数据自行添加即可
 */
/// 姓名(全名)
@property (nonatomic, copy) NSString *fullName;

/// email
@property (nonatomic, copy) NSString *email;

/// 联系电话
@property (nonatomic, copy) NSString *telephoneNum;

/// 姓名字母索引 (用于归类)
@property (nonatomic, copy) NSString *index;

/**
 实例对象便利构造器
 
 @param contact 单个联系人信息
 @return 联系人模型对象
 */
- (instancetype)initWithCNContact:(CNContact *)contact;

/**
 类便利构造器
 
 @param contact 单个联系人信息
 @return 联系人模型对象
 */
+ (instancetype)contactsModelWithCNContact:(CNContact *)contact;

/**
 联系人数据转模型数据集合
 
 @param contacts 联系人数据集合
 @return 联系人模型数据集合
 */
+ (NSArray <HHBGetContactsModel *> *)contactModelsWithArray:(NSArray <CNContact *> *)contacts;

/**
 获取通讯录联系人信息

 @return 自定义模型 联系人数据集合
 */
+ (NSArray <HHBGetContactsModel *> *)getContacts;

@end

NS_AVAILABLE_IOS(9_0)
@interface HHBGetContactsCategoryModel : NSObject

/// 索引
@property (nonatomic, copy, readonly) NSString *index;

/// 索引对应的姓名集合
@property (nonatomic, copy, readonly) NSArray <HHBGetContactsModel *> *contactsArray;

/**
 获取当前设备排序分类后的数据模型集合
 
 @return HHBContactCategoryModel对象数据集合
 */
+ (NSArray <HHBGetContactsCategoryModel *> *)getContactsCategoryModel;

@end
