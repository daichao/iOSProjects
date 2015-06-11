//
//  DCFileUPLOADViewController.m
//  DCNetWork
//
//  Created by bokeadmin on 15/6/10.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCFileUPLOADViewController.h"
#define kUrl @"http://scmhacks.skypiea.info:3000/~daichao/repo/bokesoft/"
#define kBOUNDARY_STRING @"DAICHAO"

@interface DCFileUPLOADViewController (){
    UITextField *_textField;
    UIButton *_button;
    
}

@end

@implementation DCFileUPLOADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    
}

#pragma mark 界面布局
-(void)layoutUI{
    //地址栏
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, 300, 25)];
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textField.textColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0];
    _textField.text=@"pic.jpg";
    [self.view addSubview:_textField];
    //上传按钮
    _button=[[UIButton alloc]initWithFrame:CGRectMake(10, 500, 300, 25)];
    [_button setTitle:@"上传" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(uploadFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

#pragma mark 取得请求链接
-(NSURL *)getUploadUrl:(NSString *)fileName{
    NSString *urlStr=[NSString stringWithFormat:@"%@?file=%@",kUrl,fileName];
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}
#pragma mark 取得mime types
-(NSString *)getMIMETypes:(NSString *)fileName{
    return @"image/jpg";
}
#pragma mark 取得数据体
-(NSData *)getHttpBody:(NSString *)fileName{
    NSMutableData *dataM=[NSMutableData data];
    NSString *strTop=[NSString stringWithFormat:@"--%@\nContent-Disposition: form-data; name=\"file1\"; filename=\"%@\"\nContent-Type: %@\n\n",kBOUNDARY_STRING,fileName,[self getMIMETypes:fileName]];
    NSString *strBottom=[NSString stringWithFormat:@"\n--%@--",kBOUNDARY_STRING];
    NSString *filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *fileData=[NSData dataWithContentsOfFile:filePath];
    [dataM appendData:[strTop dataUsingEncoding:NSUTF8StringEncoding]];
    [dataM appendData:fileData];
    [dataM appendData:[strBottom dataUsingEncoding:NSUTF8StringEncoding]];
    return dataM;
}

#pragma mark 上传文件
-(void)uploadFile{
    NSString *fileName=_textField.text;
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[self getUploadUrl:fileName] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0f];
    
    request.HTTPMethod=@"POST";
    
    NSData *data=[self getHttpBody:fileName];
    
    //通过请求头设置
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBOUNDARY_STRING] forHTTPHeaderField:@"Content-Type"];
    
    //设置数据体
    request.HTTPBody=data;
    
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError){
            NSLog(@"error:%@",connectionError.localizedDescription);
        }
    }];
}


@end
