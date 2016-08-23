//
//  ZYMonitorPanel.m
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/23.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import "ZYMonitorPanel.h"
#import "ZYMonitorManager.h"
#import "ZYCPUMonitorModel.h"

@interface ZYMonitorPanel()

@property(nonatomic, strong) UILabel *cpuLabel;
@property(nonatomic, strong) ZYMonitorManager *monitorManager;
@end

@implementation ZYMonitorPanel

#pragma mark Life Cycle

+ (instancetype)shareInstance {
    static ZYMonitorPanel *monitorPanel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitorPanel = [[ZYMonitorPanel alloc] initWithFrame:CGRectMake(0, 100, 120, 30)];
    });
    return monitorPanel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _needShow = YES;
        _monitorManager = [ZYMonitorManager shareInstance];
        self.tapAction = ^{
            NSLog(@"TAP ON DragView");
        };
        [self addModelObserver];
        [self loadSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cpuLabel.backgroundColor = [UIColor greenColor];
    CGRect cpuLabelRect = CGRectMake(20, 5, self.frame.size.width - 25, self.frame.size.height - 10);
    self.cpuLabel.frame = cpuLabelRect;
    self.backgroundColor = [UIColor yellowColor];
}

- (void)dealloc {
    [[ZYCPUMonitorModel shareInstance] removeObserver:self forKeyPath:@"percent"];
}

#pragma mark Private Methods

- (void)loadSubViews {
    [self addSubview:self.cpuLabel];
}

- (void)addModelObserver {
    [[ZYCPUMonitorModel shareInstance] addObserver:self
                                        forKeyPath:@"percent"
                                           options:NSKeyValueObservingOptionNew
                                           context:nil];
}

#pragma mark - Key Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if (!newValue) {
        newValue = @(0);
    }
    if ([object isKindOfClass:[ZYCPUMonitorModel class]]) {
        CGFloat cpu = [newValue floatValue] * 100;
        self.cpuLabel.text = [NSString stringWithFormat:@"CPU:%.1f %%",cpu];
        return;
    }
}

#pragma mark Setters & Getters

- (UILabel *)cpuLabel {
    if (!_cpuLabel) {
        _cpuLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _cpuLabel;
}
@end
