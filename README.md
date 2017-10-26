# HBGetContact
获取通讯录联系人信息

> 提示：
> 当前demo用的是AddressBook库，该库是C语言的API，注意内存管理，不影响使用；

> iOS9.0后，苹果推出了Contacts库，此库使用的OC更加的面相对象，以后有时间再写一套吧。


注意：获取手机通讯录需要用户开启权限，在info.plist文件中添加如下：
```xml
<key>NSContactsUsageDescription</key>
	<string>当前应用需要获取您的通讯录(这个自己可以随意写)</string>
 ```
 
 Demo中只是获取了用户的姓名，联系电话、email(如果有的话)，需要其它信息的自己可以配置添加。
 
 > 获取方式：
 > 在HHBGetContact.m文件中的 - (NSArray *)_getContactsOfPhone; 方法中
 
 ```objc
 - (NSArray *)_getContactsOfPhone{
    const ABAddressBookRef *addressBooks = nil;
    NSMutableArray *contactM = [[NSMutableArray alloc] init];
    ......
    ......
    ......
    // 省略部分见demo
    
    // 遍历每个人的信息
    for (NSInteger i = 0; i < peopleCount; i++){
         NSMutableDictionary *contactDict = [NSMutableDictionary dictionary];
        // 获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeoples, i);
        // 获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        ......
        // 此处可以拿到其它相关信息
        ......
        
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
            ......
            ......
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) {
                valuesCount = ABMultiValueGetCount(valuesRef);
            }
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            // 获取联系电话和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: { // 联系电话
                        self.telephoneNum = (__bridge NSString*)value;
                        [contactDict setObject:self.telephoneNum forKey:@"telephoneNum"];
                        break;
                    }
                    case 1: { // Email
                        self.email = (__bridge NSString*)value;
                        [contactDict setObject:self.email forKey:@"email"];
                        break;
                    }
                    ...... // 获取其他信息
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        // 将个人信息添加到数组中
        [contactM addObject:contactDict];
        
        // 释放相关指针变量指向的内存空间
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        
        // 注意：其他的信息需要释放掉，不然会有内存泄漏，此处用的是C语言的API，需要手动管理内存，
    }
    return contactM.copy;
}
 ```
 
简单说道这儿，若有不足或错误的地方欢迎指正 ^……^ ！
