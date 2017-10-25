//
//  HHBContactTableViewCell.h
//  HHBGetContact
//
//  Created by DylanHu on 2017/10/08.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HHBExtension.h"
#import "HHBContactModel.h"

@interface HHBContactTableViewCell : UITableViewCell
@property (nonatomic, strong) HHBContactModel *contact;
@end
