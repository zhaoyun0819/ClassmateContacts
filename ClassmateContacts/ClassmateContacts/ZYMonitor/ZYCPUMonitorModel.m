//
//  ZYCPUMonitorModel.m
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/21.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import "ZYCPUMonitorModel.h"
#import <mach/mach.h>

#define MAX_HISTORY (128)

@implementation ZYCPUMonitorModel

#pragma mark Life Cycle

+ (instancetype)shareInstance {
    static ZYCPUMonitorModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ZYCPUMonitorModel alloc] init];
    });
    return model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.percent = 0.0f;
        self.history = [NSMutableArray array];
        for(int i = 0; i < MAX_HISTORY; i++) {
            [self.history addObject:@(0)];
        }
    }
    return self;
}

- (void)dealloc {
    [self.history removeAllObjects];
    self.history = nil;
}

#pragma mark Private Methods

- (void)update
{
    kern_return_t			kr = { 0 };
    task_info_data_t		tinfo = { 0 };
    mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return;
    
    task_basic_info_t		basic_info = { 0 };
    thread_array_t			thread_list = { 0 };
    mach_msg_type_number_t	thread_count = { 0 };
    
    thread_info_data_t		thinfo = { 0 };
    thread_basic_info_t		basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return;
    
    long	tot_sec = 0;
    long	tot_usec = 0;
    float	tot_cpu = 0;
    self.threadCount = thread_count;
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec		= tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec	= tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu		= tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return;
    
    
    [self.history addObject:[NSNumber numberWithFloat:tot_cpu]];
    
    if ( [self.history count] > MAX_HISTORY )
    {
        [self.history removeObjectsInRange:NSMakeRange(0, [self.history count] - MAX_HISTORY)];
    }
    
    self.percent = tot_cpu;
}

@end
