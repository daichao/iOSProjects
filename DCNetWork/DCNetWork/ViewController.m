//
//  ViewController.m
//  DCNetWork
//
//  Created by bokeadmin on 15/6/10.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>{
    NSMutableData *_data;
    UITextField *_textField;
    UIButton *_button;
    UIProgressView *_progressView;
    UILabel *_label;
    long long _totalLength;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}

-(void)layoutUI{
    //地址栏
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, 300, 25)];
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textField.textColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0];
    _textField.text=@"iOS Programming - The Big Nerd Ranch Guide 4ed.pdf";
    
    [self.view addSubview:_textField];
    
    //进度条
    _progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(10, 100, 300, 25)];
    [self.view addSubview:_progressView];
    //状态显示
    _label=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, 300, 25)];
    _label.textColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0];;
    [self.view addSubview:_label];
    //下载按钮
    _button=[[UIButton alloc]initWithFrame:CGRectMake(10, 500, 300, 25)];
    [_button setTitle:@"下载" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(sendRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

#pragma mark 更新进度
-(void)updateProgress{
    if(_data.length==_totalLength){
        _label.text=@"下载完成";
    }else{
        _label.text=@"正在下载...";
        [_progressView setProgress:_data.length/_totalLength];
    }
}

#pragma mark 发送数据请求
-(void)sendRequest{
    NSString *urlStr=[NSString stringWithFormat:@"http://scmhacks.skypiea.info:3000/~daichao/repo/bokesoft/%@",_textField.text];
    //对url进行编码否则无法读取中文，解码用
    //stringByRemovingPercentEncoding
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    /*创建请求
     cachePolicy:缓存策略
     a.NSURLRequestUseProtocolCachePolicy 协议缓存，根据response中的Cache-Control字段判断缓存是否有效，如果缓存有效则使用缓存数据否则重新从服务器请求
     b.NSURLRequestReloadIgnoringLocalCacheData 不使用缓存，直接请求新数据
     c.NSURLRequestReloadIgnoringCacheData 等同于 SURLRequestReloadIgnoringLocalCacheData
     d.NSURLRequestReturnCacheDataElseLoad 直接使用缓存数据不管是否有效，没有缓存则重新请求
     eNSURLRequestReturnCacheDataDontLoad 直接使用缓存数据不管是否有效，没有缓存数据则失败
     timeoutInterval:超时时间设置（默认60s）
     */
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    //创建连接
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    //启动连接
    [connection start];
}

#pragma mark 连接代理方法
#pragma mark 开始响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"receive response.");
    _data=[[NSMutableData alloc]init];
    _progressView.progress=0;
    
    //通过响应头中的Content-length取得整个响应的总长度
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse*)response;
    NSDictionary *httpResponseHeaderFields=[httpResponse allHeaderFields];
    _totalLength=[[httpResponseHeaderFields objectForKey:@"Content-Length"]longLongValue];
    
}


#pragma mark 接受响应数据(根据响应内容的大小此方法会被重复调用)
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"receive data.");
    
//连续接受数据
    [_data appendData:data];
    //更新进度
    [self updateProgress];
}


#pragma mark 数据接受完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"loading finish.");
    //数据接收完保存文件(注意苹果官方要求：下载数据只能保存在缓存目录)
    NSString *savePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    savePath=[savePath stringByAppendingPathComponent:_textField.text];
    [_data writeToFile:savePath atomically:YES];
    
    NSLog(@"path :%@",savePath);
}

#pragma mark 请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //如果连接超时或者连接地址错误可能就会报错
    NSLog(@"connection error,error detail is :%@",error.localizedDescription);
}





@end
