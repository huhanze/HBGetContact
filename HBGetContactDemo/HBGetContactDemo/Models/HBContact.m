//
//  HBContact.m
//  HBGetContactDemo
//
//  Created by 胡海波 on 15/10/13.
//  Copyright © 2015年 Dylan.Hu. All rights reserved.
//

#import "HBContact.h"

@implementation HBContact

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.telephoneNum = dict[@"telephoneNum"];
        self.email = dict[@"email"];
    }
    return self;
}

+ (instancetype)contactWithDictionary:(NSDictionary *)dict{
    
    return [[self alloc] initWithDictionary:dict];
}

+ (NSArray *)dictionaryToModel:(NSArray *)array{
    
    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        
        HBContact *contact = [HBContact contactWithDictionary:dict];
        [modelArray addObject:contact];
    }
    return modelArray.copy;
}

@end
