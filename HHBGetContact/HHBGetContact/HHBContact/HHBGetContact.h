//
//  HBGetContact.h
//  GetAddress
//
//  Created by DylanHu on 15/10/12.
//  Copyright © 2015年 DylanHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface HHBGetContact : NSObject

/**
 获取手机通讯录信息

 @return 通讯录集合
 */
+ (NSArray *)getAllcontactsOfPhone;

@end
