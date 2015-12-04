//
//  ViewController.m
//  LTInfiniteScrollView
//
//  Created by ltebean on 14/11/21.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "SFTestViewController.h"
#import "Masonry.h"
#import "SFConstants.h"

@interface SFTestViewController ()

@end

@implementation SFTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *v1 = [self layoutCenter];
//    
//    UIView *v2 = [self layoutInsets:v1];
//    
//    [self layoutParallelRectangle:v2];
    
    [self layoutContentCaculate];
}

-(UIView *)layoutCenter{
    
    WeakSelf(weakSelf);
    UIView *sv = [UIView new];
    sv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    return sv;
}

-(UIView *)layoutInsets:(UIView *)superView{
    
    UIView *sv = [UIView new];
    sv.backgroundColor = [UIColor redColor];
    [superView addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    return sv;
}

#define PADDING 10

-(void)layoutParallelRectangle:(UIView *)superView{
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor yellowColor];

    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor grayColor];
    
    [superView addSubview:view1];
    [superView addSubview:view2];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(superView.mas_centerY);
        make.left.mas_equalTo(superView.mas_left).with.offset(PADDING);
        make.right.mas_equalTo(view2.mas_left).with.offset(-PADDING);
        make.height.mas_equalTo(@150);
        make.width.mas_equalTo(view2);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(superView.mas_centerY);
        make.left.equalTo(view1.mas_right).with.offset(PADDING);
        make.right.equalTo(superView.mas_right).with.offset(-PADDING);
        make.height.equalTo(@150);
        make.width.equalTo(view1);
        
    }];
}

-(void)layoutContentCaculate{
    WeakSelf(weakSelf);
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING));
    }];
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    int count = 20;
    UIView *lastView = nil;
    for (int i = 1; i < count; i++) {
        UIView *subView = [UIView new];
        [container addSubview:subView];
        subView.backgroundColor = [UIColor colorWithRed:(arc4random() % 256 / 256.0)
                                                   green:(arc4random() % 256 / 256.0)
                                                   blue:(arc4random() % 256 / 256.0)
                                                   alpha:1];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(container);
            make.height.mas_equalTo(@(20*i));
            if (lastView) {
                make.top.mas_equalTo(lastView.mas_bottom);
            }else{
                make.top.mas_equalTo(container.mas_top);
            }
        }];
        
        lastView = subView;
        
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom);
    }];
}

@end
