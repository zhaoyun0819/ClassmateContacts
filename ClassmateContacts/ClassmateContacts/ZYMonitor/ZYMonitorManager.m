//
//  ZYMonitorManager.m
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/21.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import "ZYMonitorManager.h"
#import "ZYCPUMonitorModel.h"
@interface ZYMonitorManager()

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *models;

@end
@implementation ZYMonitorManager

#pragma mark Life Cycle

+ (instancetype)shareInstance {
    static ZYMonitorManager *monitorManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitorManager = [[ZYMonitorManager alloc] init];
    });
    return monitorManager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _models = [NSMutableArray array];
        [_models addObject:[ZYCPUMonitorModel shareInstance]];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f / 10.0f
                                                  target:self
                                                selector:@selector(didTimeout)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark Private Methods

-(void)didTimeout{
    [_models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj respondsToSelector:@selector(update)]) {
            [obj performSelector:@selector(update)];
        }
//        if ([obj isKindOfClass:ZYCPUMonitorModel.class]) {
//            ZYCPUMonitorModel *cpu = (ZYCPUMonitorModel *)obj;
//            [self checkCpuIsNeedAlarm:cpu];
//        }
    }];
}

//- (void)checkCpuIsNeedAlarm:(ZYCPUMonitorModel *)cpu{
//    //触发条件：CPU使用率持续 100%超过2秒 90%超过3秒 80%超过4秒 70%超过5秒
//    [self times:20 percentage:100 cpu:cpu];
//    [self times:30 percentage:90 cpu:cpu];
//    [self times:40 percentage:80 cpu:cpu];
//    [self times:50 percentage:70 cpu:cpu];
//}
//
//- (void)times:(NSInteger)times percentage:(NSInteger)percentage cpu:(ZYCPUMonitorModel *)cpu{
//    if ([cpu.history count] > times) {
//        NSMutableArray *cpuArr = nil;
//        NSInteger location = [cpu.history count] - times;
//        NSRange range = {location, times};
//        cpuArr = [cpu.history subarrayWithRange:range];
//        NSInteger cpuSize = 0;
//        for (NSNumber *num in cpuArr) {
//            cpuSize += [num integerValue];
//        }
//        if (cpuSize/times * 100 > percentage) {
//            printf("--------------------------alarm--%ld------------------------", (long)percentage);
//        }
//    }
//}

@end
