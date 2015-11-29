//
//  SFGroupManager.m
//  DonkeyMate
//
//  Created by tarena on 15/11/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFHeartManager.h"
#import "SFCommucationTool.h"

#define MESSAGE_HEART @"MESSAGE_HEART" //消息：心跳

/**
 *  监听实体类
 */
@interface ListentEntity : NSObject

/**
 *  最近一次更新事件
 */
@property (nonatomic, strong)NSDate *lastUpdateTime;

/**
 *  被监听人
 */
@property(nonatomic, strong)SFPersonEnity *person;

/**
 *  更新监听事件
 */
-(void)updateTime;

+(id)listenWithPerson:(SFPersonEnity *)person;

@end

@implementation ListentEntity

/**
 *  更新最近一次心跳时间
 */
-(void)updateTime{
    self.lastUpdateTime = [NSDate new];
}

+(id)listenWithPerson:(SFPersonEnity *)person{
    
    ListentEntity *listener = [ListentEntity new];
    listener.lastUpdateTime = [NSDate new];
    listener.person = person;
    person.loginTime = [NSDate new];

    
    return listener;
}

@end

@interface SFHeartManager()

/**
 *  在线朋友
 */
@property (nonatomic, strong)NSMutableDictionary *friendsMutableDictionary;

/**
 *  当前是否在监听
 */
@property (nonatomic, assign)BOOL isListening;

/**
 *  是否正在发送心跳
 */
@property (nonatomic, assign)BOOL isHeartSending;

/**
 *  任务下线操作
 */
@property (nonatomic, copy)PersonOnLineBlock onlineBlock;
@property (nonatomic, copy)PersonOffLineBlock offLineBlock;
@property (nonatomic, copy)PersonLocationUpgradeBlock locatinUpgradeBlock;
@property (nonatomic, copy)PersonTalkingBlock personTalkingBlock;

/**
 *  我自己
 */
@property (nonatomic, strong)SFPersonEnity *mySelf;

/**
 *  监听计时器
 */
@property(nonatomic, strong)NSTimer *monitorTimer;

/**
 *  心跳计时器
 */
@property(nonatomic, strong)NSTimer *heartTimer;

@end

@implementation SFHeartManager

-(id)initWithSelf:(SFPersonEnity *)mySelf{
    if (self = [super init]) {
        self.mySelf = mySelf;
        //默认心跳周期为一秒
        self.interval = HEART_INTERVAL;
    }
    return self;
}

-(id)initWithWithSelf:(SFPersonEnity *)mySelf andPersonOnLine:(PersonOnLineBlock)personOnLineBlock andPersonOffLine:(PersonOffLineBlock)personOffLineBlock andPersonLocationUpgrade:(PersonLocationUpgradeBlock)presonLocationUpgrade{
    if (self = [super init]) {
        
        self.mySelf = mySelf;
        
        self.onlineBlock = personOnLineBlock;
        self.offLineBlock = personOffLineBlock;
        self.locatinUpgradeBlock = presonLocationUpgrade;
        
        //默认心跳周期为一秒
        self.interval = HEART_INTERVAL;
    }
    return self;
}

-(void)setBlockPersonOnLine:(PersonOnLineBlock)personOnLineBlock andPersonOffLine:(PersonOffLineBlock)personOffLineBlock andPersonLocationUpgrade:(PersonLocationUpgradeBlock)presonLocationUpgrade{
    self.onlineBlock = personOnLineBlock;
    self.offLineBlock = personOffLineBlock;
    self.locatinUpgradeBlock = presonLocationUpgrade;
}

/**
 *  配置Block
 *
 *  @param personOnLineBlock     上线处理
 *  @param personOffLineBlock    下线处理
 *  @param presonLocationUpgrade 位置更新处理
 *
 */
-(void)setBlockPersonOnLine:(PersonOnLineBlock)personOnLineBlock andPersonOffLine:(PersonOffLineBlock)personOffLineBlock andPersonLocationUpgrade:(PersonLocationUpgradeBlock)presonLocationUpgrade andPersonTalking:(PersonTalkingBlock)personTalking{
    [self setBlockPersonOnLine:personOnLineBlock andPersonOffLine:personOffLineBlock andPersonLocationUpgrade:presonLocationUpgrade];
    self.personTalkingBlock = personTalking;
}

-(void)startMonitor{
    //如果在监听，则返回
    if (self.isListening) {
        return;
    }
    
    //开启线程监听
    self.isListening = YES;
    [self.monitorTimer fire];
    
    //开启线程发送心跳
    [self startHeart];
}

-(void)listenWithPerson:(SFPersonEnity *)person{
    ListentEntity *listener = [self.friendsMutableDictionary valueForKey:person.name];
    if (listener == nil) {
        
        listener = [ListentEntity listenWithPerson:person];
        [self.friendsMutableDictionary setObject:listener forKey:person.name];
        
        //上线处理
        self.onlineBlock(person);
        
    }else{
        //跟新心跳时间
        [listener updateTime];
        
        //如果跟新位置，则测发位置更新操作
        if(listener.person.coordinate.longitude != person.coordinate.longitude
           ||listener.person.coordinate.latitude != person.coordinate.latitude){
            self.locatinUpgradeBlock(person);
            
            //更新用户信息
            listener.person.coordinate = person.coordinate;
        }
        
        if (person.chattingContent.count > 0) {
            //添加聊天内容
            [listener.person.chattingContent addObject:[person.chattingContent lastObject]];
            self.personTalkingBlock(person);
        }
    }
}

-(void)listenWithPerson:(SFPersonEnity *)person andContent:(NSString *)content{
    
    if ((content != nil)&&![content isEqualToString:@""]&&![self isHeartPopWithContent:content]) {
        [person.chattingContent addObject:content];
    }
    
    [self listenWithPerson:person];
}

/**
 *  检测是否有人掉线
 */
-(void)checkFriendsOffLine{
    
    NSArray *array = [[self.friendsMutableDictionary copy]allValues];
    
    for (ListentEntity *listenTarget in array) {
        
        //如果超出监听事件，则触发掉线操作
        if (([NSDate date].timeIntervalSince1970 - listenTarget.lastUpdateTime.timeIntervalSince1970) > self.interval * 2) {
            
            //移除监听对象
            [self.friendsMutableDictionary removeObjectForKey:listenTarget.person.name];
            
            //下线处理
            self.offLineBlock(listenTarget.person);

        }
    }
}

/**
 *  发送心跳
 */
-(void)sendHeartPop{
//    if (self.mySelf.coordinate.latitude == 0
//        && self.mySelf.coordinate.longitude ==0) {
//        //如果经纬度都为0，表示不能定位，则不发送
//        return;
//    }
    
    [[SFCommucationTool sharedAsyCommunictionSocket] sendMessageWithMessage:MESSAGE_HEART andPerson:self.mySelf];
}

/**
 *  结束监听
 */
-(void)stopMonitor{
    
    self.isListening = NO;
    
    [self.monitorTimer invalidate];
    
    [self.friendsMutableDictionary removeAllObjects];
    
}

/**
 *  开始心跳
 */
-(void)startHeart{
    self.isHeartSending = YES;
    [self.heartTimer fire];
}

/**
 *  停止心跳
 */
-(void)stopHeart{
    self.isHeartSending = NO;
    [self.heartTimer invalidate];
    self.heartTimer = nil;
}

/**
 *  判断是否为心跳消息
 *
 *  @param message 发过来的消息
 *
 *  @return YES 是心跳， NO不是
 */
-(BOOL)isHeartPopWithMessage:(SFMessageEntity *)message{
    if ([message.content  isEqual: MESSAGE_HEART]) {
        return YES;
    }
    return NO;
}

-(BOOL)isHeartPopWithContent:(NSString *)content{
    if ([content isEqual: MESSAGE_HEART]) {
        return YES;
    }
    return NO;
}

-(BOOL)isMonitorOn{
    return _isListening;
}

-(BOOL)isHeartOn{
    return _isHeartSending;
}

- (NSMutableDictionary *)friendsMutableDictionary {
	if(_friendsMutableDictionary == nil) {
		_friendsMutableDictionary = [[NSMutableDictionary alloc] init];
	}
	return _friendsMutableDictionary;
}

- (NSTimer *)heartTimer {
	if(_heartTimer == nil) {
		_heartTimer = self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(sendHeartPop) userInfo:nil repeats:YES];
	}
	return _heartTimer;
}

- (NSTimer *)monitorTimer {
	if(_monitorTimer == nil) {
		_monitorTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(checkFriendsOffLine) userInfo:nil repeats:YES];
	}
	return _monitorTimer;
}

-(NSArray *)friendsOnline{
    
    NSMutableArray *friendMutableArray = [NSMutableArray array];
    
    for (ListentEntity *listener in [self.friendsMutableDictionary allValues]) {
        [friendMutableArray addObject:listener.person];
    }
    
    return [friendMutableArray copy];
}

@end


