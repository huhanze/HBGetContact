//
//  HBGetContact.m
//  GetAddress
//
//  Created by 胡海波 on 15/10/12.
//  Copyright © 2015年 胡海波. All rights reserved.
//

#import "HBGetContact.h"
@interface HBGetContact()

@property (nonatomic,assign) NSInteger recordID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *telephoneNum;

@property (nonatomic,strong) NSMutableDictionary *contacts;

@end
@implementation HBGetContact

#pragma mark --- 获取用户通讯录所有信息
- (NSMutableArray *)getAllcontactsOfPhone{
    
    const ABAddressBookRef *addressBooks = nil;
    NSMutableArray *contactM = [[NSMutableArray alloc] init];
    // iOS6.0以上版本需要开启权限
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
        });
    }
    
    else {
        addressBooks = ABAddressBookCreate();
    }
    
    // 获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++){
        
         NSMutableDictionary *contactDict = [NSMutableDictionary dictionary];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        self.name = nameString;
        self.recordID = (int)ABRecordGetRecordID(person);
        [contactDict setObject:self.name forKey:@"name"];
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        self.telephoneNum = (__bridge NSString*)value;
                        [contactDict setObject:self.telephoneNum forKey:@"telephoneNum"];
                        break;
                    }
                    case 1: {// Email
                        self.email = (__bridge NSString*)value;
                        [contactDict setObject:self.email forKey:@"email"];
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);

        }
        //将个人信息添加到数组中，循环完成后addressBookArray中包含所有联系人的信息
        [contactM addObject:contactDict];
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    return contactM;
}

+ (NSMutableArray *)getAllcontactsOfPhone{
    
    return [[[self alloc] init] getAllcontactsOfPhone];
}
@end
