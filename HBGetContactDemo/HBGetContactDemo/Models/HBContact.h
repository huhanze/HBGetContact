//
//  HBContact.h
//  HBGetContactDemo
//
//  Created by 胡海波 on 15/10/13.
//  Copyright © 2015年 Dylan.Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBContact : NSObject

/**姓名*/
@property (nonatomic,copy) NSString *name;

/**电话*/
@property (nonatomic,copy) NSString *telephoneNum;

/**Email*/
@property (nonatomic,copy) NSString *email;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)contactWithDictionary:(NSDictionary *)dict;
+ (NSArray *)dictionaryToModel:(NSArray *)array;

@end
