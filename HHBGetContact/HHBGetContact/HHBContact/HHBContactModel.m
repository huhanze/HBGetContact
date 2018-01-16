//
//  HHBContactModel.m
//  HHBGetContact
//
//  Created by DylanHu on 2015/10/25.
//  Copyright © 2015年 DylanHu. All rights reserved.
//

#import "HHBContactModel.h"
#import "NSString+HHBPinyinString.h"
#import "HHBGetContact.h"

@implementation HHBContactModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if ([dictionary.allKeys containsObject:@"name"]) {
            NSString *word = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
            _name = word;
            _letterStr = word.pinyinString;
            _index = [self.letterStr.uppercaseString substringToIndex:1];
            char tempIndex = [_index characterAtIndex:0];
            if (!(tempIndex >= 'A' && tempIndex <= 'Z')) {
                _index = @"#";
            }
        }
        if ([dictionary.allKeys containsObject:@"email"]) {
            NSString *email = [NSString stringWithFormat:@"%@",dictionary[@"email"]];
            _email = email;
        }
        if ([dictionary.allKeys containsObject:@"telephoneNum"]) {
            NSString *telephoneNum = [NSString stringWithFormat:@"%@",dictionary[@"telephoneNum"]];
            _telephoneNum = telephoneNum;
        }
    }
    return self;
}

+ (instancetype)contactModelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

+ (NSArray <HHBContactModel *> *)contactModelsWithArray:(NSArray *)dataArray {
    NSMutableArray *modelArray = nil;
    if (dataArray.count) {
        modelArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dict in dataArray) {
            HHBContactModel *model = [HHBContactModel contactModelWithDictionary:dict];
            [modelArray addObject:model];
        }
    }
    return modelArray.copy;
}

@end

// ------------------------------------------------------------------
@interface HHBContactCategoryModel()

/// 索引
@property (nonatomic, copy) NSString *index;

/// 索引对应的国家集合
@property (nonatomic, copy) NSArray <HHBContactModel *> *contactsArray;

@end

@implementation HHBContactCategoryModel

#pragma mark - 分类排序联系人数据
+ (NSArray <HHBContactCategoryModel *> *)contactsCategoryModesWithArray:(NSArray *)dataArray {
    NSMutableDictionary *dict = @{}.mutableCopy;
    NSMutableArray *indexArray = @[].mutableCopy;
    NSMutableArray *modelArray = @[].mutableCopy;
    NSArray *contactModelsArray = [HHBContactModel contactModelsWithArray:dataArray];
    for (HHBContactModel *model in contactModelsArray) {
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
        HHBContactCategoryModel *categoryModel = [[HHBContactCategoryModel alloc] init];
        categoryModel.index = index;
        NSMutableArray *contactsArray = [[dict objectForKey:index] mutableCopy];
        [contactsArray sortUsingComparator:^NSComparisonResult(HHBContactModel *obj1, HHBContactModel *obj2) {
            return [obj1.name.pinyinString compare:obj2.name.pinyinString];
        }];
        categoryModel.contactsArray = contactsArray.copy;
        [modelArray addObject:categoryModel];
    }
    
    return modelArray.copy;
}

#pragma mark - 获取当前设备的联系人集合数据(已分类排序)
+ (NSArray <HHBContactCategoryModel *> *)getContactsCategoryModel {
    return [self contactsCategoryModesWithArray:[HHBGetContact getAllcontactsOfPhone].copy];
}

@end
