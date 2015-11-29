//
//  SFAnimatePickerView.m
//  DonkeyMate
//
//  Created by tarena on 15/11/3.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFAnimatePickerView.h"
#import "SFConstants.h"



@interface SFAnimatePickerView()
//@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation SFAnimatePickerView


/**
 *  设定弹出或隐藏选择器
 *
 *  @param view   执行动画所对应的师徒
 *  @param hidden 隐藏还是显示： YES 隐藏 NO 显示
 */
- (void)viewAnimation:(UIView*)view willHidden:(BOOL)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = CGRectMake(0, 480, 320, 260);
        } else {
            [view setHidden:hidden];
            view.frame = CGRectMake(0, 230, 320, 260);
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
}

//防止横屏时，自定义视图的拉伸效果
//调用时机：读取TRNavLeftView.xib的时候(反归档/解码)
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

+(id)animatePickerViewWithInView:(UIView *)view{
 
    SFAnimatePickerView *animatePickerView = (SFAnimatePickerView *)[[[NSBundle mainBundle] loadNibNamed:@"SFAnimatePickerView" owner:nil options:nil] firstObject];
    animatePickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 160);
    animatePickerView.toolbar.barTintColor = [SFConstants themeColor];
    [view.superview addSubview:animatePickerView];
    return animatePickerView;
    
}

-(void)show{
    [self viewAnimation:self willHidden:NO];
    [self.superview bringSubviewToFront:self];
}

-(void)hide{
    [self viewAnimation:self willHidden:YES];
}

- (IBAction)cancel:(id)sender {
    [self hide];
}

- (IBAction)save:(id)sender {
    [self hide];
}



@end
