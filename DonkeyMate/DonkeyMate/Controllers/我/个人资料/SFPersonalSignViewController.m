//
//  SFPersonalSignViewController.m
//  DonkeyMate
//
//  Created by tarena on 15/11/2.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFPersonalSignViewController.h"



@interface SFPersonalSignViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextField;
@property (weak, nonatomic) IBOutlet UILabel *resetCharNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation SFPersonalSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTextField.delegate = self;
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick:)];
    NSLog(@"%@", self.textLabel.textColor);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveClick:(id)sender {
    //发送消息到，数据更新成功
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_PERSON_SIGN object:nil userInfo:@{NOTIFICATION_UPDATE_PERSON_SIGN: self.contentTextField.text}];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"%s", __func__);
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"%s", __func__);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (range.location >= 50) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    int resetAllowedCharNumber = 50 - textView.text.length;
    
    self.resetCharNumberLabel.text = [NSString stringWithFormat:@"剩余%@个可编辑", @(resetAllowedCharNumber)];
}

@end
