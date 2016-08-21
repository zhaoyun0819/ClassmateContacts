//
//  TFTableViewCell.m
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/13.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import "TFTableViewCell.h"

@interface TFTableViewCell()

@end

@implementation TFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.textField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor lightGrayColor];
    CGRect labelRect = CGRectMake( 30, 10, 50, 30);
    self.label.frame = labelRect;
    
    if(![_labelStr isEqualToString:@""]) {
        _label.text = _labelStr;
        [_label sizeToFit];
    }
    CGFloat w = self.frame.size.width;
    CGFloat h = self.label.frame.size.height;
    CGRect textFieldRect = CGRectMake(30, 10 + h + 10, w - 60, 30);
    self.textField.frame = textFieldRect;
}

# pragma mark - Setters & Getters

- (void)setLabelStr:(NSString *)labelStr {
    _labelStr = labelStr;
    _label.text = _labelStr;
    [_label sizeToFit];
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor whiteColor];
    }
    return _label;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.backgroundColor = [UIColor whiteColor];

        
        [_textField addObserver:self forKeyPath:@"text"
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:nil];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(textFieldTextDidChangeSimutanusly:)
         name:UITextFieldTextDidChangeNotification
         object:_textField];
    }
    return _textField;
}

# pragma mark - Private Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        _label.text = _textField.text;
        [_label sizeToFit];
    }
    
}

- (void)textFieldTextDidChangeSimutanusly:(NSNotification *)aNotification {
    _label.text = _textField.text;
}

- (void)dealloc {
    [_textField removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
