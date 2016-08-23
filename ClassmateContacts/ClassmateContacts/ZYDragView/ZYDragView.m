//
//  ZYDragView.m
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/21.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import "ZYDragView.h"

@interface ZYDragView()

@property(nonatomic, unsafe_unretained) CGPoint beginPoint;
@property(nonatomic, unsafe_unretained) BOOL isMovable;
@property(nonatomic, unsafe_unretained) BOOL isMoving;

@end

@implementation ZYDragView

#pragma mark Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.isMovable = YES;
        self.isMoving = NO;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onTap)];
        [self addGestureRecognizer:tgr];
    }
    return self;
}

#pragma mark Private Methods

- (void)onTap {
    if (self.tapAction) {
        self.tapAction();
    }
}

- (void)moveBonusViewCenter {
    if(_isMoving)
        return;
    if (self.center.x >= self.superview.frame.size.width / 2) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(self.superview.frame.size.width - self.frame.size.width,
                                    self.center.y - self.frame.size.height / 2,
                                    self.frame.size.width,
                                    self.frame.size.height);
        }];
        
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0,
                                    self.center.y - self.frame.size.height / 2,
                                    self.frame.size.width,
                                    self.frame.size.height);
        }];
    }
}

#pragma mark Touches Methods Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _isMoving = NO;
    if (_isMovable) {
        UITouch *touch = [touches anyObject];
        _beginPoint = [touch locationInView:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    _isMoving = YES;
    if (_isMovable) {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
        CGFloat offsetX = currentPoint.x - _beginPoint.x;
        CGFloat offsetY = currentPoint.y - _beginPoint.y;
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        if(self.center.y > (self.superview.frame.size.height - self.frame.size.height / 2)) {
            self.center = CGPointMake(self.center.x,
                                      self.superview.frame.size.height - self.frame.size.height / 2);
        } else if(self.center.y < self.frame.size.height / 2) {
            self.center = CGPointMake(self.center.x,
                                      self.frame.size.height / 2);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _isMoving = NO;
    if (_isMovable) {
        [self moveBonusViewCenter];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    _isMoving = NO;
}
@end
