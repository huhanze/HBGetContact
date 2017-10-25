//
//  HHBContactModel.h
//  HHBGetContact
//
//  Created by DylanHu on 2015/10/25.
//  Copyright © 2015年 DylanHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHBContactModel : NSObject

/// 姓名
@property (nonatomic, copy) NSString *name;

/// email
@property (nonatomic, copy) NSString *email;

/// 联系电话
@property (nonatomic, copy) NSString *telephoneNum;

/// 索引（Word的首个大写字母，或者汉语拼音的首个大写字母）
@property (nonatomic, copy, readonly) NSString *index;

/// 拼音名称(英文名称则为全部转换成小写的字符串)
@property (nonatomic, copy, readonly) NSString *letterStr;

/**
 实例对象便利构造器

 @param dictionary 单个联系人信息
 @return 联系人模型对象
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 类便利构造器
 
 @param dictionary 单个联系人信息
 @return 联系人模型对象
 */
+ (instancetype)contactModelWithWithDictionary:(NSDictionary *)dictionary;

/**
 联系人数据转模型数据集合

 @param dataArray 联系人数据集合
 @return 联系人模型数据集合
 */
+ (NSArray <HHBContactModel *> *)contactModelsWithArray:(NSArray *)dataArray;

@end

@interface HHBContactCategoryModel : NSObject

/// 索引
@property (nonatomic, copy, readonly) NSString *index;

/// 索引对应的姓名集合
@property (nonatomic, copy, readonly) NSArray <HHBContactModel *> *contactsArray;

/**
 联系人数据转化为排序分类后的数据模型集合

 @param dataArray 联系人集合数据
 @return HHBContactCategoryModel对象数据集合
 */
+ (NSArray <HHBContactCategoryModel *> *)contactsCategoryModesWithArray:(NSArray *)dataArray;

/**
 获取当前设备排序分类后的数据模型集合

 @return HHBContactCategoryModel对象数据集合
 */
+ (NSArray <HHBContactCategoryModel *> *)getContactsCategoryModel;

@end
