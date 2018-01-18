# HBGetContact
获取通讯录联系人信息

> 提示：
> 当前demo用的是AddressBook库，该库是C语言的API，注意内存管理，不影响使用；

> iOS9.0后，苹果推出了Contacts库，此库使用的OC更加的面相对象，以后有时间再写一套吧。


注意：iOS10以后获取手机通讯录需要用户开启权限，在info.plist文件中添加如下：
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
 
 ***
 
 <font color = sky-blue size = 5> 续写 :</font>
 
 几年前写了上边这种获取通讯录联系的人方式，最近几天也不是很忙，想着继续完善一下，目前基本绝大多数的APP开始从9.0版本适配。Apple在iOS9.0以后推出了一套OC的API获取通讯录，相比之前的做了很多优化，获取方式也更简单、更方便了，更加地面向对象。下面就针对这套API来简单给出方案。
 
iOS9.0 Apple推出了Contacts.Framework 和 ContactsUI.framework, 前一个是和纯库，后一个则是通讯录UI库。关于ContactsUI.framework就不多说了，因为整个界面是调取设备通讯录的，一般用的不是很多，调用也不是很难。

下面来说说Contacts.Framework：

先看看Contacts.h文件中引入了哪些头文件

```objc
#import <Contacts/CNContact.h>
#import <Contacts/CNContact+Predicates.h>
#import <Contacts/CNMutableContact.h>
#import <Contacts/CNContact+NSItemProvider.h>

#import <Contacts/CNLabeledValue.h>
#import <Contacts/CNPhoneNumber.h>
#import <Contacts/CNPostalAddress.h>
#import <Contacts/CNMutablePostalAddress.h>
#import <Contacts/CNInstantMessageAddress.h>
#import <Contacts/CNSocialProfile.h>
#import <Contacts/CNContactRelation.h>

#import <Contacts/CNGroup.h>
#import <Contacts/CNGroup+Predicates.h>
#import <Contacts/CNMutableGroup.h>

#import <Contacts/CNContainer.h>
#import <Contacts/CNContainer+Predicates.h>

#import <Contacts/CNContactFormatter.h>
#import <Contacts/CNPostalAddressFormatter.h>

#import <Contacts/CNContactVCardSerialization.h>
#import <Contacts/CNContactsUserDefaults.h>
#import <Contacts/CNContactProperty.h>
#import <Contacts/CNError.h>

```

这些头文件将各部分功能进行了抽离和划分，层次很清楚，可以根据自己的需求，进行相关的调用，这里我主要对已有的通讯录数据进行获取功能。

先来看看CNContact.h头文件

```objc
/// 联系人类型枚举
typedef NS_ENUM(NSInteger, CNContactType)
{
    CNContactTypePerson,  // 个人
    CNContactTypeOrganization,  // 组织
} NS_ENUM_AVAILABLE(10_11, 9_0);

/// 联系人排序枚举，根据指定的类型可以对联系人进行排序
typedef NS_ENUM(NSInteger, CNContactSortOrder)
{
    CNContactSortOrderNone, 
    CNContactSortOrderUserDefault,
    CNContactSortOrderGivenName,
    CNContactSortOrderFamilyName,
} NS_ENUM_AVAILABLE(10_11, 9_0);

/// 当前设备中联系人的唯一标识
@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *identifier;

/// 联系人类型
@property (readonly, NS_NONATOMIC_IOSONLY) CNContactType contactType;

/// name 前缀
@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *namePrefix;
......
......
......

/// 联系电话，这里存储的是CNLabeledValue类型的数组，email等等也是通过此方式存储
@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSArray<CNLabeledValue<CNPhoneNumber*>*>  *phoneNumbers;

```

其它的头文件就不一一说明了，官方文档写的很清楚，接下来直接切入正题。

获取通讯录先的检查权限，获取授权状态,在CNContactStore类中提供相应的方法。

```objc
/// 授权状态枚举
typedef NS_ENUM(NSInteger, CNAuthorizationStatus)
{
    /*! 用户还没选择授权，一般在第一次调用时会弹窗 */
    CNAuthorizationStatusNotDetermined = 0,
    /*! 用户无法改变授权状态，可能由于其它的一些原因，比如父母控制 */
    CNAuthorizationStatusRestricted,
    /*! 用户拒绝访问通讯录 */
    CNAuthorizationStatusDenied,
    /*! 用户已经授权 */
    CNAuthorizationStatusAuthorized
}
```

```objc
CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

// 拿到状态后判断是否满足条件，授权成功则直接请求通讯录，未授权则先同意授权之后，在请求获取通讯录

```

请求获取通讯录：
> 先创建一个获取请求，CNContactFetchRequest类创建一个请求
> CNContactFetchRequest类创建一个请求时需要指定要获取联系人的哪些数据，如姓名、手机、邮箱、地址等等，每个数据的item苹果都给了对应的key 

```objc
// Properties that are always fetched. Can be used with key value coding and observing.
CONTACTS_EXTERN NSString * const CNContactIdentifierKey                      NS_AVAILABLE(10_11, 9_0);

// Optional properties that can be fetched. Can be used with key value coding and observing.
CONTACTS_EXTERN NSString * const CNContactNamePrefixKey                      NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactGivenNameKey                       NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactMiddleNameKey                      NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactFamilyNameKey                      NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactPreviousFamilyNameKey              NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactNameSuffixKey                      NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactNicknameKey                        NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactOrganizationNameKey                NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactDepartmentNameKey                  NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactJobTitleKey                        NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactPhoneticGivenNameKey               NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactPhoneticMiddleNameKey              NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactPhoneticFamilyNameKey              NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactPhoneticOrganizationNameKey        NS_AVAILABLE(10_12, 10_0);
CONTACTS_EXTERN NSString * const CNContactBirthdayKey                        NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactNonGregorianBirthdayKey            NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactNoteKey                            NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactImageDataKey                       NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactThumbnailImageDataKey              NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactImageDataAvailableKey              NS_AVAILABLE(10_12, 9_0);
CONTACTS_EXTERN NSString * const CNContactTypeKey                            NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactPhoneNumbersKey                    NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactEmailAddressesKey                  NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactPostalAddressesKey                 NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactDatesKey                           NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactUrlAddressesKey                    NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactRelationsKey                       NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactSocialProfilesKey                  NS_AVAILABLE(10_11, 9_0);
CONTACTS_EXTERN NSString * const CNContactInstantMessageAddressesKey         NS_AVAILABLE(10_11, 9_0);

```

这里我就拿姓名和手机、邮箱来举例。

```objc
/// 设置需要访问的数据
NSArray *keys = @[CNContactIdentifierKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]];

/// 创建请求
CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
```
在上面的keys数据中使用了CNContactFormatter来获取全名，由于老外的姓名跟咱国家的姓名差别(中国姓在前名在后，大多数以英语为母语的国家都是名在前姓在后)，这样就完美的处理这些问题。

接下来就是获取了。

```objc
// 来存储联系人数据
NSMutableArray *contactM = @[].mutableCopy;
    
CNContactStore *store = [[CNContactStore alloc] init];
[store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
    [contactM addObject:contact];
}];

```

这样获取数据已经完成了，而且contactM数据基本已经排好序，简单吧，有木有。当然这个数组里面存储的是CNContact对象数据，下面就对这些数据进一步解析，封装成咱们用起来更方便的模型数据。

为了与上边第一种方式获取通讯录中的自定义模型数据区分，这里我有单独创建了一个新的解析Model - HBGetContactsModel

```objc
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

```

定义了两个类，HHBGetContactsModel和HHBGetContactsCategoryModel，HHBGetContactsModel转换CNContact数据，HHBGetContactsCategoryModel组装最终显示在UITableView中的分组数据

这样数据这一块已经完成，关于UI自己可以根据自己的需求设计，一般大多数APP其实主要是需要用户的数据，对界面并不是特别在意，直接使用ContactsUI.framework的也不多，重要的还是在数据这一块。

对比两种方式，iOS9.0以后的这API还是很好用的，排序这一块其实就是基本已经排好的，我们做的只是分类就好了，效率很高。而iOS9.0以前的获取放是在中文转换拼音这一过程很耗时，而且多音字问题还得处理等等。推荐后一种方法。


