//
//  HHBContactTableViewCell.h
//  HHBGetContact
//
//  Created by DylanHu on 2017/10/08.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HHBExtension.h"

@class HHBContactModel,HHBGetContactsModel;
@interface HHBContactTableViewCell : UITableViewCell
@property (nonatomic, strong) HHBContactModel *contact;

/// 联系人模型 iOS9.0以后使用
@property (nonatomic, strong) HHBGetContactsModel *contactModel NS_CLASS_AVAILABLE_IOS(9_0);

@end
