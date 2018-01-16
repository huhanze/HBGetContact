//
//  HBGetContactsModel.h
//  HHBGetContact
//  联系人模型 --- 针对处理CNContact(iOS9.0以后)数据的处理
//  Created by DylanHu on 2018/1/16.
//  Copyright © 2018年 DylanHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNContact;
@interface HBGetContactsModel : NSObject

/*
 这里就用以下三个属性数据作为例子，其它数据自行添加即可
 */
/// 姓名(全名)
@property (nonatomic, copy) NSString *fullName;

/// email
@property (nonatomic, copy) NSString *email;

/// 联系电话
@property (nonatomic, copy) NSString *telephoneNum;

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
+ (NSArray <HBGetContactsModel *> *)contactModelsWithArray:(NSArray <CNContact *> *)contacts;

@end
