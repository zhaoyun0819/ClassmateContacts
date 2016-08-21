//
//  ZYCPUMonitorModel.h
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/21.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYCPUMonitorModel : NSObject

@property(nonatomic,assign) float percent;
@property(nonatomic,assign) NSInteger threadCount;      //!< 线程数量
@property(nonatomic,strong) NSMutableArray * history;

+(instancetype)shareInstance;
-(void)update;

@end
