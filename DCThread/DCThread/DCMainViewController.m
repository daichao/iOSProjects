//
//  ViewController.m
//  DCThread
//
//  Created by bokeadmin on 15/6/9.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCMainViewController.h"
#import "DCImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define  CELL_SPACING 10

@interface DCMainViewController (){
//    UIImageView *_imageView;
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
//    NSMutableArray *_threads;
    
}

@end

@implementation DCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];

}

#pragma mark 界面布局
-(void)layoutUI{
    //创建多个图片空间用于显示图片
    _imageViews=[NSMutableArray array];
    for(int r=0;r<ROW_COUNT;r++){
        for(int c=0;c<COLUMN_COUNT;c++){
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
//    _imageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
//    _imageView.contentMode=UIViewContentModeScaleAspectFit;
//    [self.view addSubview:_imageView];
    //加载按钮
    UIButton *buttonStart=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame=CGRectMake(50, 500, 220, 25);
    [buttonStart setTitle:@"加载图片" forState:UIControlStateNormal];
    
    //添加方法
    [buttonStart addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStart];
//    
//    //停止按钮
//    UIButton *buttonStop=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    buttonStop.frame=CGRectMake(160, 500, 100, 25);
//    [buttonStop setTitle:@"停止加载" forState:UIControlStateNormal];
//    
//    //添加方法
//    [buttonStop addTarget:self action:@selector(stopLoadImage) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:buttonStop];
//    
    
    //创建图片链接
    _imageNames=[NSMutableArray array];
   for(int i=0;i<15;i++){
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",i]];
    }
}

#pragma  mark 将图片显示到界面
//-(void)updateImage:(NSData *)imageData{
//    UIImage *image=[UIImage imageWithData:imageData];
//    _imageView.image=image;
//}
//-(void)updateImage:(DCImageData *)imageData{
//    UIImage *image=[UIImage imageWithData:imageData.data];
//    UIImageView *imageView=_imageViews[imageData.index];
//    imageView.image=image;
//}

-(void)updateImageWithData:(NSData *)data andIndex:(int)index{
    UIImage *image=[UIImage imageWithData:data];
    UIImageView *imageView=_imageViews[index];
    imageView.image=image;
}


#pragma mark 请求图片数据
//-(NSData *)requestData{
//    //对于多线程操作建议把线程操作放到@autoreleasepool中
//    @autoreleasepool {
//        NSURL *url=[NSURL URLWithString:@"http://images.apple.com/v/iphone-6/b/images/overview/biggest_right_large.png"];
//        NSData *data=[NSData dataWithContentsOfURL:url];
//        return data;
//    }
//}
-(NSData *)requestData:(int)index{
    @autoreleasepool {
//        if(index!=(ROW_COUNT*COLUMN_COUNT-1)){
//            [NSThread sleepForTimeInterval:2.0];
//        }如果不是最后一张图片，则线程暂停2秒，使最后一张图片优先下载
//        NSURL *url=[NSURL URLWithString:@"http://images.apple.com/v/iphone-6/b/images/overview/biggest_right_large.png"];
        NSURL *url=[NSURL URLWithString:_imageNames[index]];
        NSData *data=[NSData dataWithContentsOfURL:url];
        return  data;
    }
}
#pragma mark 加载图片
//-(void)loadImage{
//    //请求数据
//    NSData *data=[self requestData];
//    /*
//     将数据显示到UI控件,注意只能在主线程中更新UI,
//     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
//     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
//     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
//     waitUntilDone:是否线程任务完成执行
//     */
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
//}

-(void)loadImage:(NSNumber *)index{
//    NSLog(@"current thread:%@",[NSThread currentThread]);
//    
//    int i=[index intValue];
//    NSData *data=[self requestData:i];
//    
//    NSThread *currentThread=[NSThread currentThread];
//    //如果当前线程处于取消状态，则退出当前线程
//    if(currentThread.isCancelled){
//        NSLog(@"Thread(%@) will be cancelled!",currentThread);
//        [NSThread exit];
//    }
//    DCImageData *imageData=[[DCImageData alloc]init];
//    imageData.index=i;
//    imageData.data=data;
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
    int i=[index intValue];
    //请求数据
    NSData *data=[self requestData:i];
    NSLog(@"%@",[NSThread currentThread]);
    //更新UI界面，此处调用了主线程队列的方法(mainQueue是UI主线程)
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self updateImageWithData:data andIndex:i];
    }];
}
#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    //方法1：使用对象方法
    //NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //方法2：使用类方法
//    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
    
    //创建多个线程用于填充图片
//    for(int i=0;i<ROW_COUNT*COLUMN_COUNT;++i){
//        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
//        thread.name=[NSString stringWithFormat:@"myThread %i",i];
//        [thread start];
//    }
    
    
   
//    int count=ROW_COUNT*COLUMN_COUNT;
//     _threads=[NSMutableArray arrayWithCapacity:count];
//    //创建多个线程用于填充图片
//    for(int i=0;i<count;++i){
//        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
//        thread.name=[NSString stringWithFormat:@"myThread %i",i];
////        if(i==(count-1)){
////            thread.threadPriority=1.0;
////        }
////        else {
////            thread.threadPriority=0.0;
////        }设置线程优先级，值为0~1，1最大
//        [_threads addObject:thread];
//    }
//    //循环启动线程
//    for(int i=0;i<count;i++){
//        NSThread *thread=_threads[i];
//        [thread start];
//    }
    
    
    
    /*
     创建一个调用操作
     object:调用方法参数
     */
//    
//    NSInvocationOperation *invocationOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImage:) object:nil];
//    
//    //创建网NSInvocationOperation 对象并不会调用，它由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线程中调用，一般不会这么操作，而是添加到NSOperationQueue中
//    //[invacationOperation start];
//    
//    //创建操作队列
//    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
//    //注意添加到 操作队后，队列会开启一个线程执行此操作
//    [operationQueue addOperation:invocationOperation];



    int count=ROW_COUNT*COLUMN_COUNT;
    //创建操作队列
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];

    operationQueue.maxConcurrentOperationCount=5;//设置最大并发线程数
    
    NSBlockOperation *lastBlockOperation=[NSBlockOperation blockOperationWithBlock:^{
        [self loadImage:[NSNumber numberWithInt:(count-1)]];
    }];
    //创建多个线程用于填充图片
    for(int i=0;i<count;i++){
        NSBlockOperation *blockOperation=[NSBlockOperation blockOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]];
        }];
        //设置依赖操作作为最后一张图片加载操作
        [blockOperation addDependency:lastBlockOperation];
        [operationQueue addOperation:blockOperation];
//       [operationQueue addOperationWithBlock:^{
//           [ self loadImage:[NSNumber numberWithInt:i]];
//       }];
    }
    //将最后一个图片的加载操作加入线程队列
    [operationQueue addOperation:lastBlockOperation];
    
}


#pragma mark 停止加载图片
//-(void)stopLoadImage{
//    for(int i=0;i<ROW_COUNT*COLUMN_COUNT;i++){
//        NSThread *thread=_threads[i];
//        if(!thread.isFinished){
//            [thread cancel];
//        }
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
