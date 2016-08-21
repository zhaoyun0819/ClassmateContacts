//
//  TFTableViewCell.h
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/13.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, copy) NSString *labelStr;

@end
