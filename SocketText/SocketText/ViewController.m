//
//  ViewController.m
//  SocketText
//
//  Created by 乔乐 on 17/3/20.
//  Copyright © 2017年 乔乐. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>
@property(nonatomic,strong)GCDAsyncSocket * socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(connectToServer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)connectToServer:(id)sender {
    // 1.与服务器通过三次握手建立连接
    NSString *host = @"192.165.56.71";
    int port = 8000;
    
    //创建一个socket对象
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //连接
    NSError *error = nil;
    
    
    if (![_socket connectToHost:host onPort:port error:&error]) {
        NSLog(@"错误%@",error);
    }
}
#pragma mark -socket的代理
#pragma mark 连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"链接成功%s",__func__);
    NSString *str=@"helloworld";
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:1];
    
}


#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"连接失败");
    }else{
        NSLog(@"正常断开");
    }
}
#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"发送数据成功%s",__func__);

    //发送完数据手动读取，-1不设置超时
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%s %@",__func__,receiverStr);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
