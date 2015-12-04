//
//  SFCommucationTool.m
//  DonkeyMate
//
//  Created by tarena on 15/10/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFCommucationTool.h"
#import "SFMessageEntity.h"
#import "SFApplication.h"

@interface SFCommucationTool()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@end

@implementation SFCommucationTool

#pragma mark --- public method

/**
 *  通过person和message实体类生成通讯命令
 *
 *  @param person  消息发送人
 *  @param message 消息信息
 *
 *  @return 通讯命令
 */
+(NSData *)getCommunicationCommandWithPerson:(SFPersonEnity *)person andMessage:(SFMessageEntity *)message{
    
#warning 待优化
    
    if (person==nil) {
        return nil;
    }
    
    
    NSDictionary *personDic = @{@"name":person.name, @"coordinate": @{@"latitude":@(person.coordinate.latitude), @"longitude":@(person.coordinate.longitude)}, @"imageURL": person.imageURL};
    NSDictionary *messageDic = @{@"content":message.content};
//    
//    NSDictionary *personDic = [SFDataMetalTool object2JsonWithObject:person andClass:[SFPersonEnity class]];
//    NSDictionary *messageDic = [SFDataMetalTool object2JsonWithObject:message andClass:[SFMessageEntity class]];
//    
    NSDictionary *commandDic = @{@"person": personDic, @"message": messageDic};
    
    NSData *data = nil;
    
    //判定是否数组类型可以转成JSON对象
    BOOL isConverted = [NSJSONSerialization isValidJSONObject:commandDic];
    if (isConverted) {
        //如果第二步yes，转成JSON对象(NSJSONSerialization)
        NSError *error = nil;
        data = [NSJSONSerialization dataWithJSONObject:commandDic options:NSJSONWritingPrettyPrinted error:&error];
        //验证：打印转换后的对象
        if (!error) {
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", message);
            
            NSString *sendMessage = [NSString stringWithFormat:@"papapa %@ %@",COMMAND_SPERAOTR,  message];
            NSLog(@"%@", sendMessage);
            
            data = [sendMessage dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            NSLog(@"%s", __func__);
            NSLog(@"无法转换:%@", error.userInfo);
        }
    }
    
    return data;
}


/**
 *  通过通讯命令解析出消息发送人
 *
 *  @param communicationMessage 通讯命令
 *
 *  @return 消息发送人
 */
+(SFPersonEnity *)getPersonWithCommunicationMessage:(NSData *)communicationMessage{
    SFPersonEnity *personEntity = [SFPersonEnity new];
#warning 待优化
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:communicationMessage options:0 error:&error];
    if (error
        ||!dictionary) {
        NSLog(@"%s", __func__);
        NSLog(@"无法转换:%@", error.userInfo);
        return nil;
    }
    NSDictionary *personDic = dictionary[@"person"];
    personEntity.name = personDic[@"name"];
    NSDictionary *coordinate = personDic[@"coordinate"];
    
    
    personEntity.coordinate = CLLocationCoordinate2DMake([coordinate[@"latitude"] doubleValue], [coordinate[@"longitude"] doubleValue]);
    personEntity.imageURL = personDic[@"imageURL"];
    
    return personEntity;
}

/**
 *  通过通讯命令解析出消息
 *
 *  @param communicationMessage 通讯命令
 *
 *  @return 消息内容
 */
+(SFMessageEntity *)getMessageWithCommunicationMessage:(NSData *)communicationMessage{
#warning 待优化
    SFMessageEntity *messageEntity = [SFMessageEntity new];
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:communicationMessage options:0 error:&error];
    if (error
        ||!dictionary) {
        //转换失败
        NSLog(@"%s", __func__);
        NSLog(@"无法转换:%@", error.userInfo);
        return nil;
    }
    NSDictionary *messageDic = dictionary[@"message"];
    messageEntity.content = messageDic[@"content"];
    return messageEntity;
}

static SFCommucationTool *_communicatonTool;

-(instancetype)init{
    if (self == [super init]) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:_communicatonTool delegateQueue:dispatch_get_main_queue()];
        _asyncSocket.delegate = self;
    }
    return self;
}

+(id)sharedAsyCommunictionSocket{
    if (!_communicatonTool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _communicatonTool = [SFCommucationTool new];
        });
    }
    
    return _communicatonTool;
}

/**
 *  连接到主机
 *
 *  @param ipAddress 主机ip地址
 *  @param person    连接人详细信息
 */
-(void)connectToHostWithIpAddress:(NSString *)ipAddress andPerson:(SFPersonEnity *)person{
    //判定两个textField不能输入为空
    if (ipAddress.length == 0) {
        NSLog(@"ip地址必须指定");
        return;
    }
//    //初始化asyncSokcet对象，指定delegate
//    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //连接host主机
    NSError *error = nil;
    if(![_asyncSocket connectToHost:ipAddress onPort:SERVICE_IP_PORT withTimeout:5 error:&error]) {
        NSLog(@"连接错误/超时:%@", error.userInfo);
        return;
    }
    
////    //已经连接成功; 发送数据
//    //iam:xxx (模拟登陆服务器的操作)
    [[SFCommucationTool sharedAsyCommunictionSocket]sendMessageWithMessage:@"" andPerson:person];
}



/**
 * 发送消息
 *
 *  @param message 消息内容
 *  @param person  发送人信息
 */
- (void)sendMessageWithMessage:(NSString *)message andPerson:(SFPersonEnity *)person {

    //生成消息对象
    SFMessageEntity *messageEntity = [SFMessageEntity new];
    messageEntity.content = message;
    
    [self sendMessageWithMessageEntity:messageEntity andPerson:person];
}

/**
 *  发送消息
 *
 *  @param message 消息实体对象
 *  @param person  消息发送人
 */
- (void)sendMessageWithMessageEntity:(SFMessageEntity *)message andPerson:(SFPersonEnity *)person{
    
    NSData *sendData = [SFCommucationTool getCommunicationCommandWithPerson:person andMessage:message];

    //发送消息
    [self.asyncSocket writeData:sendData withTimeout:-1 tag:0];
    
    //设定等待接收服务器的数据的状态
    [_asyncSocket readDataWithTimeout:-1 tag:0];
    
}

#pragma mark --- GCDAsyncDelegate
//连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功");
    //设定等待接收服务器的数据的状态
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
    
//    [NSNotificationCenter defaultCenter]postNotificationName: object:<#(id)#> userInfo:<#(NSDictionary *)#>
}
//写成功
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"写成功啦");
}
//接收来自服务器的数据(Read)
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"接收来自服务器的数据");

    //接收数据并转换为消息对象，解析出实体类
    NSString *receiveData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", receiveData);
    
    //获得消息实体对象
    SFMessageEntity *messageEntity = [SFCommucationTool getMessageWithCommunicationMessage:data];
    
    //获得人实体对象
    SFPersonEnity *personEntity = [SFCommucationTool getPersonWithCommunicationMessage:data];
    
    //如果不能生成对应的实体对象
    if(messageEntity == nil
       || personEntity == nil)return;

    //发送接收到得消息给地图去显示
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_COMMUNICATION_RECEIVE object:self userInfo:@{NOTIFICATION_COMMUNICATION_RECEIVE_MESSAGE: messageEntity, NOTIFICATION_COMMUNICATION_RECEIVE_PERSON: personEntity}];

    //设定等待接收服务器的数据的状态
    [_asyncSocket readDataWithTimeout:-1 tag:0];
}

//timeout(读取服务器的数据)
- (NSTimeInterval) socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    NSLog(@"读取服务器数据超时");
    return -1;
}
//timeout(发送数据给服务器)
- (NSTimeInterval) socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    NSLog(@"发送数据到服务器超时");
    return -1;
}

#pragma mark --- Lazy loading
- (GCDAsyncSocket *)asyncSocket {
	if(_asyncSocket == nil) {
		_asyncSocket = [[GCDAsyncSocket alloc] init];
	}
	return _asyncSocket;
}

@end
