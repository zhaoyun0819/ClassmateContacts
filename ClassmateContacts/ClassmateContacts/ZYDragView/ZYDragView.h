//
//  ZYDragView.h
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/21.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VoidBlock)(void);
@interface ZYDragView : UIControl

@property(nonatomic, copy) VoidBlock tapAction;


@end
