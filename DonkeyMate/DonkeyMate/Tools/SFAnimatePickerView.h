//
//  SFAnimatePickerView.h
//  DonkeyMate
//
//  Created by tarena on 15/11/3.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFICATION_PIKCER_DATA_UPGRADE @"NOTIFICATION_PIKCER_DATA_UPGRADE"

@interface SFAnimatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

/**
 *  工厂方法: 获取animatePickerView对象
 *
 *  @param target <UIPickerViewDelegate, UIPickerViewDataSource>委托对象
 *
 *  @return animatePickerView对象
 */
+(id)animatePickerViewWithInView:(UIView *)view;

/**
 *  显示
 */
-(void)show;

/**
 *  隐藏
 */
-(void)hide;

@end
