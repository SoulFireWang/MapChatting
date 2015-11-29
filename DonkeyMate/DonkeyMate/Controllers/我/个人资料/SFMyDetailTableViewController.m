//
//  SFMyDetailTableViewController.m
//  DonkeyMate
//
//  Created by tarena on 15/11/1.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFMyDetailTableViewController.h"
#import "SFPersonalSignViewController.h"
#import "SFAnimatePickerView.h"
#import "SFApplication.h"
#import "UIImageView+WebCache.h"
#import "SFNameViewController.h"
#import "SFImageViewController.h"


#define COUNT_HEIGHT_LEFT 220//身高pickView可选数字总数

#define COUNT_WEIGHT_LEFT 220//左侧体重pickView可选数字总数
#define COUNT_WIGHT_RIGHT 10//右侧体重pickView可选数字总数

#define COUNT_AGE 100//年龄pickView可选数字总数

#define FORMART_HEIGHT @"%@cm" //身高格式


@interface SFMyDetailTableViewController ()<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

/**
 *  照片
 */
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *nameTableViewCell;

/**
 *  单元格：个性签名
 */
@property (weak, nonatomic) IBOutlet UITableViewCell *signTableViewCell;

/**
 *  单元格：身高
 */
@property (weak, nonatomic) IBOutlet UITableViewCell *heightTabelViewCell;

/**
 *  单元格：体重
 */
@property (weak, nonatomic) IBOutlet UITableViewCell *weightTableViewCell;

/**
 *  单元格：年龄
 */
@property (weak, nonatomic) IBOutlet UITableViewCell *ageTableViewCell;

/**
 *  单元格：性别
 */
@property (weak, nonatomic) IBOutlet UITableViewCell *genderTableViewCell;


/**
 *  选择器：身高
 */
@property (nonatomic, strong) SFAnimatePickerView *heightPickView;

/**
 *  选择器：体重
 */
@property (nonatomic, strong) SFAnimatePickerView *weightPickView;

/**
 *  选择器：年龄
 */
@property (nonatomic, strong) SFAnimatePickerView *agePickView;

/**
 *  1~10的数字数组
 */
@property (nonatomic, strong) NSArray *digitalArray;

@end

@implementation SFMyDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person = [SFApplication defoultSystemUser];
    
    [self setView];
    
    [self setRegister];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick:)];

    
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  设置视图
 */
-(void)setView{
    self.photoImageView.layer.cornerRadius =self.photoImageView.frame.size.width/6;
    self.photoImageView.layer.masksToBounds = YES;
    
    [self updateView];
}

-(void)saveClick:(id)sender{
    
    [self updatePerson];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PERSONAL_DETAIL object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  注册消息
 */
-(void)setRegister{
    
    //签名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signDidChange:) name:NOTIFICATION_UPDATE_PERSON_SIGN object:nil];
    
    //姓名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameDidChange:) name:NOTIFICATION_UPDATE_PERSON_NAME object:nil];
    
    //任务头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDidChange:) name:NOTIFICATION_UPDATE_PERSON_IMAGE  object:nil];
    
}

/**
 *  跟新界面
 */
-(void)updateView{
    
    self.photoImageView.image = [UIImage imageNamed:self.person.imageURL];
    self.nameTableViewCell.detailTextLabel.text = self.person.name;
    self.heightTabelViewCell.detailTextLabel.text = [self getHeightStringWithHeight:self.person.height];
    self.weightTableViewCell.detailTextLabel.text = [self getWeightStringWihtWight:self.person.weight];
    self.ageTableViewCell.detailTextLabel.text = [self getAgeStringWihtAge:self.person.age];
    self.signTableViewCell.detailTextLabel.text = self.person.sign;
    
    self.genderTableViewCell.detailTextLabel.text = [self getGenderWithGender:self.person.gender];
}



/**
 *  更新person对象
 */
-(void)updatePerson{
    
    self.person.name = self.nameTableViewCell.detailTextLabel.text;
    self.person.height = [self.heightTabelViewCell.detailTextLabel.text doubleValue];
    self.person.weight = [self.weightTableViewCell.detailTextLabel.text doubleValue];
    self.person.age = [self.ageTableViewCell.detailTextLabel.text integerValue];
    self.person.sign = self.signTableViewCell.detailTextLabel.text;
    self.person.gender = [self.genderTableViewCell.detailTextLabel.text isEqualToString:@"男"];
    
}

#pragma mark --- event

-(void)signDidChange:(NSNotification *)notification{
    NSString *sign = notification.userInfo[NOTIFICATION_UPDATE_PERSON_SIGN];
    self.signTableViewCell.detailTextLabel.text= sign;
    
    [self updatePerson];
}

-(void)nameDidChange:(NSNotification *)notification{
    NSString *name = notification.userInfo[NOTIFICATION_UPDATE_PERSON_NAME];
    self.nameTableViewCell.detailTextLabel.text = name;
    
    [self updatePerson];
}

-(void)imageDidChange:(NSNotification *)notification{
    NSString *imageURL = notification.userInfo[NOTIFICATION_UPDATE_PERSON_IMAGE];
    self.person.imageURL = imageURL;
    self.photoImageView.image = [UIImage imageNamed:imageURL];
    
    [self updatePerson];
}

/**
 *  身高值发生改变
 */
-(void)heightDidChange{
    [self.heightPickView hide];
    
    NSInteger value = [self.heightPickView.pickerView selectedRowInComponent:0];
    self.heightTabelViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@cm", @(value).stringValue];
    
    [self updatePerson];
}

/**
 *  年龄发生改变
 */
-(void)ageDidChange{
    [self.agePickView hide];
    
    NSInteger value = [self.agePickView.pickerView selectedRowInComponent:0];
    self.ageTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", @(value).stringValue];
    
    [self updatePerson];
}

/**
 *  体重发生改变
 */
-(void)weightDidChange{
    [self.weightPickView hide];
    
    //小数点左边的值
    NSInteger valueLeft = [self.weightPickView.pickerView selectedRowInComponent:0];
    
    //小数点右边的值
    NSInteger valueRight = [self.weightPickView.pickerView selectedRowInComponent:1];
    
    self.weightTableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@.%@公斤", @(valueLeft).stringValue, @(valueRight).stringValue];
}

#pragma mark --- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        if (indexPath.row == 3) {
            //性别设置
            UIActionSheet *genderActionSheet = [[UIActionSheet alloc] initWithTitle:@"性别选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
            [genderActionSheet showInView:self.view];
        }
        else if(indexPath.row == 0){
            //身高设置
            [self.heightPickView show];
            //获取身高单元格的的值
            NSString *height = [self.heightTabelViewCell.detailTextLabel.text stringByReplacingOccurrencesOfString:@"cm" withString:@""];
            
            //设定选中值
            [self.heightPickView.pickerView selectRow:height.integerValue inComponent:0 animated:YES];
        }else if (indexPath.row == 1){
            //体重设置
            [self.weightPickView show];
            //获取身高单元格的的值
            NSString *weight = [self.weightTableViewCell.detailTextLabel.text stringByReplacingOccurrencesOfString:@"公斤" withString:@""];
            NSArray *wightArray = [weight componentsSeparatedByString:@"."];
            NSInteger length = wightArray.count;
            //设定选中值
            [self.weightPickView.pickerView selectRow:[wightArray[0] integerValue] inComponent:0 animated:YES];
            [self.weightPickView.pickerView selectRow:(length >=2?[wightArray[1] integerValue]:0)  inComponent:1 animated:YES];
        }else if(indexPath.row == 2){
            //年龄
            [self.agePickView show];
            NSInteger age = [self.ageTableViewCell.detailTextLabel.text integerValue];
            
            [self.agePickView.pickerView selectRow:age inComponent:0 animated:YES];
        }
    }
    
    //跟新实体类person
    [self updatePerson];
}

#pragma mark --- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        self.genderTableViewCell.detailTextLabel.text = @"男";
    }else{
        self.genderTableViewCell.detailTextLabel.text = @"女";
    }
    
}

#pragma mark --- UIPickerViewDataSource/UIPickerViewDelegate
//有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == self.heightPickView.pickerView) {
        return 1;
    }else if (pickerView == self.weightPickView.pickerView){
        return 2;
    }else if (pickerView == self.agePickView.pickerView){
        return 1;
    }
    return 0;
}
//每列有几行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == self.heightPickView.pickerView) {
        return 220;
    }else if (pickerView == self.weightPickView.pickerView){
        if (component == 0) {
            return 220;
        }else{
            return 10;
        }
    }else if (pickerView == self.agePickView.pickerView){
        return 100;
    }
    return 0;
}
//每行显示什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView == self.heightPickView.pickerView) {
        return [self getHeightStringWithHeight:(double)row];
//        return [NSString stringWithFormat:@"%@ cm", [@(row) stringValue]];
    }else if (pickerView == self.weightPickView.pickerView){
        return [NSString stringWithFormat:@"%d", row];
//        return [NSString stringWithFormat:@"%@", [@(row) stringValue]];
    }else if (pickerView == self.agePickView.pickerView){
        return [self getAgeStringWihtAge:row];
//        return [NSString stringWithFormat:@"%@", [@(row) stringValue]];
    }
    return @"";
}
//当用户选择了某一行时，自动触发下方代理
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    NSLog(@"用户选择了第%d列 的 第%d行",component,row);
}


#pragma mark --- 数据值转换

/**
 *  传入身高值， 转换成显示在身高单元格中detail的字符串
 *
 *  @param height 升高值
 *
 *  @return 显示在身高单元格中detail的字符串
 */
-(NSString *)getHeightStringWithHeight:(double)height{
   return [NSString stringWithFormat:@"%@ cm", [@(height) stringValue]];
}

/**
 *  传入体重值， 转换成显示在体重单元格中detail的字符串
 *
 *  @param weight 体重值
 *
 *  @return 显示在体重单元格中detail的字符串
 */
-(NSString *)getWeightStringWihtWight:(double)weight{
    return [NSString stringWithFormat:@"%0.1f", weight];
}

/**
 *  传入体重值， 转换成显示在体重单元格中detail的字符串
 *
 *  @param weight 体重值
 *
 *  @return 显示在体重单元格中detail的字符串
 */
-(NSString *)getAgeStringWihtAge:(NSInteger)age{
    return [NSString stringWithFormat:@"%@", [@(age) stringValue]];
}


-(NSString *)getGenderWithGender:(BOOL)gender{
    return gender?@"男":@"女";
}


#pragma mark --- 懒加载

- (SFPersonEnity *)person {
    if(_person == nil) {
        _person = [[SFPersonEnity alloc] init];
    }
    return _person;
}

- (NSArray *)digitalArray {
	if(_digitalArray == nil) {
//        _digitalArray = 
	}
	return _digitalArray;
}

- (SFAnimatePickerView *)heightPickView {
	if(_heightPickView == nil) {
		_heightPickView = [SFAnimatePickerView animatePickerViewWithInView:self.view];
        _heightPickView.pickerView.dataSource = self;
        _heightPickView.pickerView.delegate = self;
        _heightPickView.saveBarButtonItem.target = self;
        _heightPickView.saveBarButtonItem.action = @selector(heightDidChange);
	}
	return _heightPickView;
}

- (SFAnimatePickerView *)weightPickView {
	if(_weightPickView == nil) {
		_weightPickView = [SFAnimatePickerView animatePickerViewWithInView:self.view];
        _weightPickView.pickerView.dataSource = self;
        _weightPickView.pickerView.delegate = self;
        _weightPickView.saveBarButtonItem.target = self;
        _weightPickView.saveBarButtonItem.action = @selector(weightDidChange);
	}
	return _weightPickView;
}

- (SFAnimatePickerView *)agePickView {
	if(_agePickView == nil) {
		_agePickView = [SFAnimatePickerView animatePickerViewWithInView:self.view];
        _agePickView.pickerView.dataSource = self;
        _agePickView.pickerView.delegate = self;
        _agePickView.saveBarButtonItem.target = self;
        _agePickView.saveBarButtonItem.action = @selector(ageDidChange);
	}
	return _agePickView;
}

@end
