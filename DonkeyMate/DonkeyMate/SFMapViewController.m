//
//  MapViewBaseDemoViewController.m
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-7-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "SFMapViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "SFCommucationTool.h"
#import "SFPersonEnity.h"
#import "SFMessageEntity.h"
#import "UIImageView+WebCache.h"
#import "SFAnnotationEntity.h"

#import "UIImageView+WebCache.h"
#import "SFMapManager.h"

#import "UIView+Screenshot.h"
#import "UIImage+ImageEffects.h"
#import "FancyTabBar.h"

//好友选择
#import "SFFriendEntity.h"
#import "SFApplication.h"
#import "SFFriendsView.h"
#import "SFFriendsTableViewCell.h"
#import "SFMapFriendTableViewCell.h"

//通讯框
#import "SFInputText.h"
#import "UUInputFunctionView.h"
#import "SFPersonHeadView.h"
#import "UUMessageCell.h"
#import "UUMessage.h"

//轨迹回放
#import "SFTrackingManager.h"

//心跳管理
#import "SFHeartManager.h"

//个人编辑
#import "SFMyHeadView.h"
#import "SFMyDetailTableViewController.h"

#define BUTTON_WIDTH 60

@interface SFMapViewController()<UIGestureRecognizerDelegate, FancyTabBarDelegate, UITableViewDataSource, UITableViewDelegate, UUInputFunctionViewDelegate,UUMessageCellDelegate>

/**
 *  定位服务
 */
@property (nonatomic, strong) BMKLocationService* locService;
@property (nonatomic, strong) BMKPointAnnotation* pointAnnotation;
@property (nonatomic, strong) BMKPointAnnotation* animatedAnnotation;
/**
 *  地图缓存
 */
@property (nonatomic, strong) NSMutableDictionary *annoticationMutableDictionary;

/**
 *  菜单界面：长按时弹出
 */
@property(nonatomic,strong) FancyTabBar *menuDialogue;
@property (nonatomic,strong) UIImageView *backgroundView;//背景图

/**
 *  好友列表
 */
@property (nonatomic, strong) UITableView *friendsTableView;

/**
 *  轨迹路径列表
 */
@property (nonatomic, strong) UITableView *tracksTableView;

/**
 *  输入框
 */
@property (nonatomic, strong) UUInputFunctionView *inputView;

/**
 *  当前说话的朋友
 */
@property (nonatomic, strong) SFPersonEnity *currentFriend;

/**
 *  朋友列表
 */
@property (nonatomic, strong) NSArray *friends;

/**
 *  路劲文件列表
 */
@property (nonatomic, strong) NSArray *tracks;

@property (nonatomic, strong) SFHeartManager *heartManager;

@property (nonatomic, strong) SFMyHeadView *myHeadView;

@property (nonatomic, strong) SFPersonHeadView *groupButton;

@property (nonatomic, strong) SFPersonHeadView *singleButton;

@property (nonatomic, assign) BOOL isGroupTalking;

@end

@implementation SFMapViewController
{
    bool _isKeyBoardOn;
}

#pragma mark --- 生命周期

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isGroupTalking = YES;
        _isKeyBoardOn = NO;
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        _isGroupTalking = YES;
        _isKeyBoardOn = NO;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self initMember];
    
    self.title = @"返回";
    
    [self.view addSubview:self.groupButton];
    [self.view addSubview:self.singleButton];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //add notification
    [self registerNotification];
    
    [self startLocation];
    
    [self addCustomGestures];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    [self.mapView setRotateEnabled:NO];

     //开启心跳检测
    [self.heartManager startMonitor];
}

-(void)initMember{
    _isGroupTalking = YES;
    _isKeyBoardOn = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
    [self showCommucationDialog];
    
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidUnload {
    //关闭心跳检测
    [self.heartManager stopMonitor];
    [super viewDidUnload];
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}




#pragma mark --- 初始化



/**
 *  通讯消息注册
 */
-(void)registerNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onGetMessage:) name:NOTIFICATION_COMMUNICATION_RECEIVE object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personalInfoDidChanged) name:NOTIFICATION_PERSONAL_DETAIL object:nil];
    
    //键盘消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)personalInfoDidChanged{
    [self.myHeadView setPerson:[SFApplication defoultSystemUser]];
    
//    self.person.imageURL = imageURL;
//    self.photoImageView.image = [UIImage imageNamed:imageURL];
}

#pragma mark --- 通信处理

/**
 *  刷新界面
 */
-(void)onGetMessage:(NSNotification *)notification{
    
    //获取消息数据
    SFPersonEnity *personEntity = notification.userInfo[NOTIFICATION_COMMUNICATION_RECEIVE_PERSON];
    SFMessageEntity *messageEntity = notification.userInfo[NOTIFICATION_COMMUNICATION_RECEIVE_MESSAGE];
    
    //心跳监听
    [self.heartManager listenWithPerson:personEntity andContent:messageEntity.content];
    
    //对心跳的处理
    if([self.heartManager isHeartPopWithMessage:messageEntity]){
        return;
    }

    [self showPerson:personEntity andMessage:messageEntity];
}

/**
 *  显示视图上的任务
 *
 *  @param person  发言人
 *  @param message 发言信息
 */
-(void)showPerson:(SFPersonEnity *)person andMessage:(SFMessageEntity *)message{
    
    [self addAnnotationWithPerson:person andMessage:message];
    
//    //视图调整：有键盘群聊
//    //发言人可见
//    if ([self isGroupChatting] && [self isKeyBoardOn]) {
//        NSLog(@"视图调整：有键盘群聊");
//        [SFMapManager adjustRegionForKeyboardOnAndGourpChattingWithSpeaker:person andMapView:_mapView andLocationService:_locService];
//        
//        return;
//    }
//    
//    //视图调整：有键盘单聊
//    //发言人可见
//    if (![self isGroupChatting] && [self isKeyBoardOn]) {
//        NSLog(@"视图调整：有键盘单聊");
//        [SFMapManager adjustRegionForKeyboardOnAndSingleChattingWithSpeaker:person andMapView:_mapView andLocationService:_locService];
//        return;
//    }
//    
//    //视图调整：没有键盘群聊
//    //视图上所有人可见
//    if ([self isGroupChatting] && ![self isKeyBoardOn]) {
//        NSLog(@"视图调整：没有键盘群聊");
//        [SFMapManager adjustRegionForKeyboardOffAndGroupChattingWithSpeaker:[self.annoticationMutableDictionary allValues] andMapView:_mapView andLocationService:_locService];
//        return;
//    }
//    
//    //视图调整：没有键盘单聊
//    //我可发言人可见
//    
//    if (![self isGroupChatting] && ![self isKeyBoardOn]) {
//        NSLog(@"视图调整：没有键盘单聊");
//        [SFMapManager adjustRegionForKeyboardOffAndSingleChattingWithSpeaker:person andMapView:_mapView andLocationService:_locService];
//        return;
//    }
}

//判断是否为群聊
-(BOOL)isGroupChatting{
    return _isGroupTalking;
}

//判断键盘有没有弹出
-(BOOL)isKeyBoardOn{
    return _isKeyBoardOn;
}


/**
 *  在地图上添加人物
 *
 *  @param person  人
 *  @param message 要说的话
 */
-(void)addAnnotationWithPerson:(SFPersonEnity *)person andMessage:(SFMessageEntity *)message{
    [self addAnnotationWithPerson:person andMessage:message andIsShowMessage:YES];
}

/**
 *  在地图上添加人物
 *
 *  @param person  人
 *  @param message 要说的话
 */
-(void)addAnnotationWithPerson:(SFPersonEnity *)person{
    SFMessageEntity *message = [SFMessageEntity messageWithContent:(NSString *)person.chattingContent.lastObject];
    
    [self addAnnotationWithPerson:person andMessage:message andIsShowMessage:YES];
}

/**
 *  在地图上添加人物
 *
 *  @param person  人
 *  @param message 要说的话
 */
-(void)addAnnotationWithPerson:(SFPersonEnity *)person andMessage:(SFMessageEntity *)message andIsShowMessage:(BOOL)isShowMessage{
    if(person.name == nil)return;
    
    //从字典中获取标签对象
    SFAnnotationEntity *annotation = [self.annoticationMutableDictionary objectForKey:person.name];
    if (annotation == nil) {
        //如果标签对象不存在
        annotation = [[SFAnnotationEntity alloc]init];
        annotation.coordinate = person.coordinate;
        annotation.title = message.content;
        annotation.person = person;
        [self.annoticationMutableDictionary setObject:annotation forKey:person.name];
    }else{
        //如果标签对象存在
        annotation.coordinate = person.coordinate;
        annotation.title = message.content;
        [_mapView removeAnnotation:annotation];
    }
    
    //弹出标签栏
    [_mapView addAnnotation:annotation];
    
    //是否显示消息
    if (isShowMessage) {
        [_mapView selectAnnotation:annotation animated:YES];
    }
}

/**
 *  界面上移除对象
 *
 *  @param person 要移除的对象
 */
-(void)removeAnnotationWithPerson:(SFPersonEnity *)person{
    //从字典中获取标签对象
    SFAnnotationEntity *annotation = [self.annoticationMutableDictionary objectForKey:person.name];
    if (annotation != nil) {
        //如果标签对象不存在
        [_mapView removeAnnotation:annotation];
        [self.annoticationMutableDictionary removeObjectForKey:person.name];
    }
}

#pragma mark --- 定位处理

-(void)startLocation{
    NSLog(@"进入普通定位态");
    
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [SFApplication defaultApplication].isLocateOn = YES;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    BMKCoordinateSpan span;
//    span.latitudeDelta = 0.01;
//    span.longitudeDelta = 0.01;
//    BMKCoordinateRegion region;
//    region.center = userLocation.location.coordinate;
//    region.span = span;
    
    BMKCoordinateRegion region = _mapView.region;
    
    region.center = userLocation.location.coordinate;
    
    [_mapView setRegion:region animated:YES];
    
//    [_mapView updateLocationData:userLocation];
    
    
    //跟新位置后，将用户更新到界面上
    //跟新系统用户位置
    [SFApplication defoultSystemUser].coordinate = userLocation.location.coordinate;
    /**
        这里取消了消息发送原因：
        在心跳管理器中循环发送心跳，如果经纬度都为0，则不发送，所以如果定位到了，就会有心跳消息发出，显示在界面上
     */
    
//    SFPersonEnity *person = [SFApplication defoultSystemUser];
//    [[SFCommucationTool sharedAsyCommunictionSocket] sendMessageWithMessage:[NSString stringWithFormat:@"%@加入了聊天室", person.name] andPerson:person];
//    if (![SFApplication defaultApplication].isLocateOn) {
        [_locService stopUserLocationService];
//    }
}

-(void)stopLocation{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@", error.userInfo);
    
    NSLog(@"location error");
}


#pragma mark --- BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SFAnnotationEntity class]])
    {
        //返回自定义类型的大头针视图
        return [SFMapManager annotationViewWithAnnotiation:(SFAnnotationEntity *)annotation andBMKMap:_mapView];
    }
    
    return nil;
}

#pragma mark --- 添加自定义的手势

- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    
    [self.view addGestureRecognizer:doubleTap];
    
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.delegate = self;
    longPress.cancelsTouchesInView = NO;
    longPress.delaysTouchesEnded = NO;
    longPress.minimumPressDuration = 0.5;
    [self.view addGestureRecognizer:longPress];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    /*
     *do something
     */
    NSLog(@"my handleSingleTap");
    
    [self.inputView endEditing:YES];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    /*
     *do something
     */
    NSLog(@"my handleDoubleTap");
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)theLongPress {
    /*
     *do something
     */
    NSLog(@"my theLongPress");
    [self.menuDialogue showInview:self.view];
    [self showFriendsListInView:self.view];
}

#pragma mark --- 列表：轨迹回放/好友查找

#define IDENTIFIER_FOR_CELL @"cell"

/**
 *  显示路径列表
 *
 *  @param view 父视图
 */
-(void)showTrackingListInView:(UIView *)view{
    if(_tracksTableView == nil)
    {
        CGRect rect = CGRectMake(10, 97, 300, 300);
        _tracksTableView = [[UITableView alloc]initWithFrame:rect style:0];
        _tracksTableView.dataSource = self;
        _tracksTableView.delegate = self;
        [_tracksTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER_FOR_CELL];
        
        _friendsTableView.backgroundColor = [UIColor clearColor];
        _friendsTableView.layer.cornerRadius = 5;
        
    }
    [self.inputView removeFromSuperview];
    [view addSubview:_tracksTableView];
}

/**
 *  显示好友列表
 */
-(void)showFriendsListInView:(UIView *)view{
    [self.inputView removeFromSuperview];
    [view addSubview:self.friendsTableView];
}

#pragma mark --- UITableViewDataSource/UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.friendsTableView) {
        return self.heartManager.friendsOnline.count;
    }
    else if(tableView == self.tracksTableView){
        return self.tracks.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.friendsTableView) {
        
        SFPersonTableViewCell *personCell = (SFPersonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CUSTOM_TABLE_CELL_STYLE_FRIEND forIndexPath:indexPath];
        NSArray *array = self.heartManager.friendsOnline;
        
        personCell.person = array[indexPath.row];
        
        return personCell;
    }else if(tableView == self.tracksTableView){
//        cell.textLabel.text = self.tracks[indexPath.row];
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.friendsTableView){
        SFFriendEntity *friend = self.heartManager.friendsOnline[indexPath.row];
        [self talkWithFriend:friend];
    }else if(tableView == self.tracksTableView){
//        [self trackingWithTrackFile:self.tracks[indexPath.row]];
        [self hideMenu];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, 300, 30);
    view.backgroundColor = [UIColor clearColor];
    return view;
}


/**
 *  我指定的好友聊天
 *
 *  @param friend 好友
 */
-(void)talkWithFriend:(SFFriendEntity *)friend{
    
    NSLog(@"%@", friend.name);
    
    self.isGroupTalking = NO;
    
    //设置当前朋友
    self.currentFriend = friend;
    
    //隐藏背景
    [self hideMenu];
    
    [self addAnnotationWithPerson:friend];
    
    //定位好友，并将地图范围切换的两个人都可是
    [self adjustSingleViewWithPerson:friend];
    
    //弹出出入框
    [self showCommucationDialog];
}


-(void)adjustGroupView{
    if (_isKeyBoardOn) {
        [SFMapManager adjustRegionForKeyboardOnAndGourpChattingWithSpeaker:self.friends andMapView:self.mapView andLocationService:self.locService];
    }else{
        [SFMapManager adjustRegionForKeyboardOffAndGroupChattingWithSpeaker:self.friends andMapView:self.mapView andLocationService:self.locService];
    }
}

-(void)adjustSingleViewWithPerson:(SFPersonEnity *)person{
    if (_isKeyBoardOn) {
        [SFMapManager adjustRegionForKeyboardOnAndSingleChattingWithSpeaker:person andMapView:self.mapView andLocationService:self.locService];
    }else{
        [SFMapManager adjustRegionForKeyboardOffAndSingleChattingWithSpeaker:person andMapView:self.mapView andLocationService:self.locService];
    }
}


-(void)adjustViewWithPerson:(SFPersonEnity *)person andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService{
    //视图调整：有键盘群聊
    //发言人可见
    if ([self isGroupChatting] && [self isKeyBoardOn]) {
        NSLog(@"视图调整：有键盘群聊");
        [SFMapManager adjustRegionForKeyboardOnAndGourpChattingWithSpeaker:self.friends andMapView:_mapView andLocationService:_locService];
        
        return;
    }
    
    //视图调整：有键盘单聊
    //发言人可见
    if (![self isGroupChatting] && [self isKeyBoardOn]) {
        NSLog(@"视图调整：有键盘单聊");
        [SFMapManager adjustRegionForKeyboardOnAndSingleChattingWithSpeaker:person andMapView:_mapView andLocationService:_locService];
        return;
    }
    
    //视图调整：没有键盘群聊
    //视图上所有人可见
    if ([self isGroupChatting] && ![self isKeyBoardOn]) {
        NSLog(@"视图调整：没有键盘群聊");
        [SFMapManager adjustRegionForKeyboardOffAndGroupChattingWithSpeaker:[self.annoticationMutableDictionary allValues] andMapView:_mapView andLocationService:_locService];
        return;
    }
    
    //视图调整：没有键盘单聊
    //我可发言人可见
    
    if (![self isGroupChatting] && ![self isKeyBoardOn]) {
        NSLog(@"视图调整：没有键盘单聊");
        [SFMapManager adjustRegionForKeyboardOffAndSingleChattingWithSpeaker:person andMapView:_mapView andLocationService:_locService];
        return;
    }
}


-(void)trackingWithTrackFile:(NSString *)trackingFile{
    SFTrackingManager *magager = [[SFTrackingManager alloc]initWithMapView:self.mapView];
//    [SFMapManager startTrackingWithTrackingFile:trackingFile];
    

}

#pragma mark --- 聊天

/**
 *  显示对话输入框
 */
-(void)showCommucationDialog{
    [self.inputView removeFromSuperview];
    [self.view.superview addSubview:self.inputView];
}


/**
 *  发送文字
 *
 *  @param funcView funcView description
 *  @param message  message description
 */
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    //测试
    //有键盘个人视角切换
//    [SFMapManager adjustRegionForKeyboardOnAndSingleChattingWithSpeaker:[SFApplication defoultSystemUser] andMapView:self.mapView andLocationService:self.locService];
//
//    //无键盘个人视角切换
//    [SFMapManager adjustRegionForKeyboardOffAndSingleChattingWithSpeaker:[SFApplication defoultSystemUser] andMapView:self.mapView andLocationService:self.locService];
    
    //有键盘群体视角切换
//    [SFMapManager adjustRegionForKeyboardOnAndGourpChattingWithSpeaker:self.heartManager.friendsOnline andMapView:self.mapView andLocationService:self.locService];
    
//    //无键盘群体视角切换
//    [SFMapManager adjustRegionForKeyboardOffAndGroupChattingWithSpeaker:self.heartManager.friendsOnline andMapView:self.mapView andLocationService:self.locService];
    
    SFMessageEntity *messageEntity = [SFMessageEntity new];
    messageEntity.content = message;
    
    self.inputView.TextViewInput.text = @"";
    
    //发送消息
    [[SFCommucationTool sharedAsyCommunictionSocket] sendMessageWithMessage:message andPerson:[SFApplication defoultSystemUser]];
}

/**
 *  键盘状态改变消息
 *
 *  @param notification 系统消息
 */
-(void)keyboardChange:(NSNotification *)notification
{
    _isKeyBoardOn = !_isKeyBoardOn;
    NSLog(@"键盘%@", _isKeyBoardOn? @"弹出":@"隐藏");
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = self.inputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.inputView.frame = newFrame;
    
    //重新定位
    if (self.isGroupTalking) {
        [self adjustGroupView];
    }else{
        [self adjustSingleViewWithPerson:self.currentFriend];
    }
    
    [UIView commitAnimations];
}


#pragma mark --- 菜单界面

/**
 *  点击取消按钮时触发
 */
- (void) didCollapse{
    
    [self removeViews];
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished) {
            [_backgroundView removeFromSuperview];
            _backgroundView = nil;
        }
    }];
}

- (void) didExpand{
    if(!_backgroundView){
        _backgroundView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backgroundView.alpha = 0;
        [self.view addSubview:_backgroundView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.6;
    } completion:^(BOOL finished) {
    }];
    
    [self.view bringSubviewToFront:_menuDialogue];
    UIImage *backgroundImage = [self.view convertViewToImage];
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    UIImage *image = [backgroundImage applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    _backgroundView.image = image;
}

- (void)optionsButton:(UIButton*)optionButton didSelectItem:(int)index{
    NSLog(@"%d", index);
    switch (index) {
        case 1:
            //显示好友列表
            [self showFriendsListInView:self.view];
            break;
        case 2:
            //显示路劲列表
            [self showTrackingListInView:self.view];
        default:
            break;
    }
}

//隐藏菜单
-(void)hideMenu{
    [self didCollapse];
}

/**
 *  移除视图
 */
-(void)removeViews{
    //移除好友列表
    [self.friendsTableView removeFromSuperview];
    
    //移除路径列表
    [self.tracksTableView removeFromSuperview];
    
    //移除菜单界面
    [self.menuDialogue removeFromSuperview];
    
    [self showCommucationDialog];
}

//隐藏按钮
-(void)hideAnnomations{
    [_mapView removeAnnotations:_mapView.annotations];
}



#pragma mark --- 懒加载

- (NSArray *)friends {
	return self.heartManager.friendsOnline;
}

- (NSMutableDictionary *)annoticationMutableDictionary {
    if(_annoticationMutableDictionary == nil) {
        _annoticationMutableDictionary = [[NSMutableDictionary alloc] init];
    }
    return _annoticationMutableDictionary;
}

- (UUInputFunctionView *)inputView {
	if(_inputView == nil) {
        _inputView = [[UUInputFunctionView alloc]initWithSuperVC:self];
        _inputView.delegate = self;
	}
	return _inputView;
}

- (SFPersonEnity *)currentFriend {
	if(_currentFriend == nil) {
		_currentFriend = [SFApplication defoultSystemUser];
	}
	return _currentFriend;
}

- (FancyTabBar *)menuDialogue {
    if(_menuDialogue == nil) {
        CGRect rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 80);
        _menuDialogue = [[FancyTabBar alloc]initWithFrame:rect];
        [_menuDialogue setUpChoices:self choices:nil withMainButtonImage:[UIImage imageNamed:@"cancel_31.929203539823px_1143862_easyicon.net (1)"]];
        _menuDialogue.alpha = 0.9;
        _menuDialogue.delegate = self;
    }
    return _menuDialogue;
}

- (NSArray *)tracks {
	if(_tracks == nil) {
		_tracks = [SFTrackingManager trackingFiles];
	}
	return _tracks;
}

- (SFHeartManager *)heartManager {
	if(_heartManager == nil) {
        
        //获取默认心跳管理器
        _heartManager = [SFApplication defaultHeartManger];
        
        __block SFMapViewController *mapVC = self;
        
        [_heartManager setBlockPersonOnLine:^(SFPersonEnity *person) {
            
            //上线处理
            SFMessageEntity *message = [SFMessageEntity messageWithContent:[NSString stringWithFormat:@"[%@]上线了", person.name]];
            
            [mapVC.friendsTableView reloadData];
            
            [mapVC addAnnotationWithPerson:person andMessage:message];
            
        } andPersonOffLine:^(SFPersonEnity *person) {
            
            //下线处理
            [mapVC removeAnnotationWithPerson:person];
            
            [mapVC.friendsTableView reloadData];
            
        } andPersonLocationUpgrade:^(SFPersonEnity *person) {
            
            //位置更新处理
            [mapVC addAnnotationWithPerson:person andMessage:[SFMessageEntity messageWithContent:[NSString stringWithFormat:@"[%@]位置发生了变化", person.name]] andIsShowMessage:NO];
            
        } andPersonTalking:^(SFPersonEnity *person) {
            [mapVC.friendsTableView reloadData];
        } ];
	}
    
	return _heartManager;
}

-(void)personOffLine:(NSTimer *)timer{
    //下线处理
    [self removeAnnotationWithPerson:timer.userInfo];
}

/**
 *  朋友列表视图
 *
 *  @return return value description
 */
- (UITableView *)friendsTableView {
    if(_friendsTableView == nil)
    {
        CGRect rect = CGRectMake(10, 70, 300, 400);
        _friendsTableView = [[UITableView alloc]initWithFrame:rect style:0];
        _friendsTableView.dataSource = self;
        _friendsTableView.delegate = self;
//        _friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //好友单元格
        [_friendsTableView registerClass:[SFMapFriendTableViewCell class] forCellReuseIdentifier:CUSTOM_TABLE_CELL_STYLE_FRIEND];
        
        _friendsTableView.separatorColor = [UIColor clearColor];
        
        self.myHeadView = [SFMyHeadView myHeadViewWithPerson:[SFApplication defoultSystemUser]];
        
        __block SFMapViewController *mapVC = self;
        
        self.myHeadView.personEditBlock = ^(SFPersonEnity *person){

            SFMyDetailTableViewController *mydetailVC = [mapVC.storyboard instantiateViewControllerWithIdentifier:@"SFMyDetailTableViewController"];
            
            mydetailVC.person = person;
            
            [mapVC.navigationController pushViewController:mydetailVC animated:YES];
        };
        
        _friendsTableView.tableHeaderView = self.myHeadView;
        
        _friendsTableView.backgroundColor = [UIColor clearColor];
        _friendsTableView.layer.cornerRadius = 5;
        
    }
	return _friendsTableView;
}



- (SFPersonHeadView *)groupButton {
	if(_groupButton == nil) {
        
        
        
        _groupButton = [[SFPersonHeadView alloc] initWithImage:@"parent_64px_1176109_easyicon.net" andWidth:BUTTON_WIDTH];
        
        _groupButton.frame = CGRectMake(10, 10, BUTTON_WIDTH, BUTTON_WIDTH);
        
        __block SFMapViewController *myVC = self;
        
        _groupButton.clickHeadBlock = ^void{
            
            myVC.isGroupTalking = YES;
            
            [myVC adjustViewWithPerson:[SFApplication defoultSystemUser] andMapView:myVC.mapView andLocationService:myVC.locService];
            
        };
	}
	return _groupButton;
}

- (SFPersonHeadView *)singleButton {
	if(_singleButton == nil) {
        
		_singleButton = [[SFPersonHeadView alloc] initWithImage:@"kid_64px_1176102_easyicon.net" andWidth:BUTTON_WIDTH];
        
        _singleButton.frame = CGRectMake(20 + BUTTON_WIDTH, 10, BUTTON_WIDTH - 10, BUTTON_WIDTH - 10);
        
        __block SFMapViewController *myVC = self;

        _singleButton.clickHeadBlock = ^void{
            
            myVC.isGroupTalking = NO;
            
            [myVC adjustViewWithPerson:[self currentFriend] andMapView:myVC.mapView andLocationService:myVC.locService];
        };
            
	}
	return _singleButton;
}

@end
