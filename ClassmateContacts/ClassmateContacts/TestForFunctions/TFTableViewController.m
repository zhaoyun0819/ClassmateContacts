//
//  TFTableViewController.m
//  ClassmateContacts
//
//  Created by ZhaoYun on 16/8/13.
//  Copyright © 2016年 BUPT. All rights reserved.
//

#import "TFTableViewController.h"
#import "TFTableViewCell.h"

@interface TFTableViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, unsafe_unretained) BOOL iskeyboardShow;
@property(nonatomic, strong) NSMutableArray *itemStrs;
@end

@implementation TFTableViewController

#pragma mark - Life Cycle

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.tableView];
}
- (void)viewWillLayoutSubviews {

    CGRect tableViewRect = self.view.frame;
    _tableView.frame = tableViewRect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addRow)];
    self.title = @"TestForFunctions";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _iskeyboardShow = NO;
    _itemStrs = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _itemStrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    [cell.textField addTarget:self
                       action:@selector(resignFirstResponder)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    cell.textField.delegate = self;
    [cell setLabelStr:_itemStrs[indexPath.row]];
    cell.textField.text = @"";
    return cell;
}

#pragma mark - Table view Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view Delegate
- (void) textFieldDidEndEditing:(UITextField *)textField{
    TFTableViewCell *cell  = (TFTableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    _itemStrs[indexPath.row] = cell.textField.text;
    [cell setLabelStr:_itemStrs[indexPath.row]];
    cell.textField.text = @"";
   [cell layoutSubviews];
}


#pragma  mark - Setters & Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    
    [_tableView registerClass:[TFTableViewCell class] forCellReuseIdentifier:@"CellId"];
    return _tableView;
}

#pragma  mark - Private Methods

- (void)resignKeyboard {
    [self resignFirstResponder];
}
- (void)addRow {
    [_itemStrs addObject:@""];
    [_tableView reloadData];
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification {
    if (_iskeyboardShow) {
        return;
    }
    _iskeyboardShow = YES;
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - keyboardRect.size.height);
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *panel;
    for(UIView *v in window.subviews)
    {
        if (v.tag == 819) {
            panel = v;
        }
    }
    
    if (panel.frame.origin.y > window.frame.size.height - keyboardRect.size.height) {
        panel.frame = CGRectMake(panel.frame.origin.x ,
                                         window.frame.size.height - keyboardRect.size.height - panel.frame.size.height,
                                         panel.frame.size.width, panel.frame.size.height);
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
        _iskeyboardShow = NO;
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height + keyboardRect.size.height);
    [UIView commitAnimations];

}

@end
