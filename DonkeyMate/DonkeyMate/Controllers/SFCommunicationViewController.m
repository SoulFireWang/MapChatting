//
//  ViewController.m
//  Demo01-Socket
//
//  Created by tarena on 15/10/16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFCommunicationViewController.h"
#import "GCDAsyncSocket.h"
#import "SFMapViewController.h"
#import "SFCommucationTool.h"


@interface SFCommunicationViewController () <GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextView *receiveMessageTextField;
@property (nonatomic, strong) SFMapViewController *mapViewController;


//socket对象
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@end

@implementation SFCommunicationViewController
- (IBAction)showMap:(id)sender {
    
    [self.navigationController pushViewController:self.mapViewController animated:YES];

    self.asyncSocket.delegate = self.mapViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.asyncSocket.delegate = self;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)connectToHost:(id)sender {
    
    
    
    
    //判定两个textField不能输入为空
    if (self.ipAddressTextField.text.length == 0) {
        NSLog(@"ip地址必须指定");
        return;
    }
    //    if (self.messageTextField.text.length == 0) {
    //        NSLog(@"不能发送空消息");
    //        return;
    //    }
    //ip地址 + 端口号
    //初始化asyncSokcet对象，指定delegate
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //连接host主机
    NSError *error = nil;
    if(![self.asyncSocket connectToHost:self.ipAddressTextField.text onPort:1025 withTimeout:5 error:&error]) {
        NSLog(@"连接错误/超时:%@", error.userInfo);
        return;
    }
    //已经连接成功; 发送数据
    //iam:xxx (模拟登陆服务器的操作)
    NSString *writeStr = [NSString stringWithFormat:@"iam:%@", self.messageTextField.text];
    NSData *writeData = [writeStr dataUsingEncoding:NSUTF8StringEncoding];
    [self.asyncSocket writeData:writeData withTimeout:-1 tag:0];
    
//    [SFCommucationTool sharedAsyCommunictionSocket]connectToHostWithIpAddress:self.ipAddressTextField.text andPerson:(SFPersonEnity *);
}

-(void)connectToHostWithIpAddress:(NSString *)ipAddress andPerson:(SFPersonEnity *)person{
    //判定两个textField不能输入为空
    if (ipAddress.length == 0) {
        NSLog(@"ip地址必须指定");
        return;
    }
    //初始化asyncSokcet对象，指定delegate
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //连接host主机
    NSError *error = nil;
    if(![self.asyncSocket connectToHost:ipAddress onPort:SERVICE_IP_PORT withTimeout:5 error:&error]) {
        NSLog(@"连接错误/超时:%@", error.userInfo);
        return;
    }
    //已经连接成功; 发送数据
    //iam:xxx (模拟登陆服务器的操作)
    NSString *writeStr = [NSString stringWithFormat:@"iam:%@", person.name];
    NSData *writeData = [writeStr dataUsingEncoding:NSUTF8StringEncoding];
    [self.asyncSocket writeData:writeData withTimeout:-1 tag:0];
}

- (IBAction)sendMessage:(id)sender {
    //拼接msg:xxx
    NSString *sendMessage = [NSString stringWithFormat:@"msg:%@", self.messageTextField.text];
    NSData *sendData = [sendMessage dataUsingEncoding:NSUTF8StringEncoding];
    //发送消息
    [self.asyncSocket writeData:sendData withTimeout:-1 tag:0];
}

#pragma mark --- GCDAsyncDelegate
//连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功");
    //设定等待接收服务器的数据的状态
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}
//写成功
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"写成功啦");
}
//接收来自服务器的数据(Read)
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //处理服务器返回的数据data
    NSString *receiveData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //显示到UITextView上
    self.receiveMessageTextField.text = receiveData;
    
    //设定等待接收服务器的数据的状态
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
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






- (SFMapViewController *)mapViewController {
	if(_mapViewController == nil) {
		_mapViewController = [[SFMapViewController alloc] init];
        self.asyncSocket.delegate = _mapViewController;
	}
	return _mapViewController;
}

@end
