//
//  ZYMonitorPanel.h
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/23.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import "ZYDragView.h"

@interface ZYMonitorPanel : ZYDragView

+ (instancetype)shareInstance;

@property (nonatomic, assign) BOOL needShow;

@end
