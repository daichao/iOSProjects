//
//  DCMainViewControllerWithGCD.m
//  DCThread
//
//  Created by bokeadmin on 15/6/9.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCMainViewControllerWithGCD.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10
#define IMAGE_COUNT 9

@interface DCMainViewControllerWithGCD (){
    NSMutableArray *_imageViews;
    NSLock *_lock;
    dispatch_semaphore_t _semaphore;//定义一个信号量 GCD信号机制，也可以解决资源抢占问题
}

@end

@implementation DCMainViewControllerWithGCD

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}

#pragma  mark 界面布局
-(void)layoutUI{
    _imageViews=[NSMutableArray array];
    for(int r=0;r<ROW_COUNT;r++){
        for(int c=0;c<COLUMN_COUNT;c++){
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING),r*ROW_HEIGHT+(r*CELL_SPACING) , ROW_WIDTH,ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    
    //创建按钮
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];

    
    //创建图片链接
    _imageNames=[NSMutableArray array];
    for(int i=0;i<IMAGE_COUNT;i++){
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",i]];
    }
    
    //初始化锁对象
//    _lock=[[NSLock alloc]init];
    
    
    //初始化信号量，参数是信号量初始值
    _semaphore=dispatch_semaphore_create(1);
    
}

#pragma mark 将图片显示到界面
-(void)updateImageWithData:(NSData*)data andIndex:(int)index{
    UIImage *image=[UIImage imageWithData:data];
    
    UIImageView *imageView=_imageViews[index];
    imageView.image=image;
    
}


#pragma mark 请求图片数据
-(NSData *)requestData:(int)index{
    NSData *data;
    NSString *name;
//    //加锁
//    [_lock lock];
//    if (_imageNames.count>0) {
//        name=[_imageNames lastObject];
//        [_imageNames removeObject:name];
//    }
//    //解锁
//    [_lock unlock];
//    @synchronized(self){
//        if (_imageNames.count>0) {
//            name=[_imageNames lastObject];
//            [NSThread sleepForTimeInterval:0.001f];
//            [_imageNames removeObject:name];
//        }
//    }
    
    /*
     信号等待
     第二个参数：等待时间
     */
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if(_imageNames.count>0){
        name=[_imageNames lastObject];
        [_imageNames removeObject:name];
    }
    //信号通知
    dispatch_semaphore_signal(_semaphore);
    
    
    if(name){
        NSURL *url=[NSURL URLWithString:name];
        data=[NSData dataWithContentsOfURL:url];
    }
    
    return data;
}
#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    //如果在串行队列中会发现当前线程打印变化完全一样，因为他们在一个线程中
//    NSLog(@"Thread is :%@",[NSThread currentThread]);
    
    int i=[index intValue];
    //请求数据
    NSData *data=[self requestData:i];
    //更新UI界面，此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue=dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImageWithData:data andIndex:i];
    });
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    int count=ROW_COUNT*COLUMN_COUNT;
    
    /*
     创建一个串行队列
     第一个 参数：队列名称
     第二个参数：队列类型
     */
    
//    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
//    //创建多个线程用于填充图片
//    for(int i=0;i<count;++i){
//        //异步执行队列任务
//        dispatch_async(serialQueue, ^{
//            [self loadImage:[NSNumber numberWithInt:i]];
//        });
//    }
    
    /*
     取得全局队列
     第一个参数：线程优先级
     第二个参数：标记参数，目前米有用，一般传入0
     */
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建多个线程用于填充图片
    for(int i=0;i<count;++i){
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
        //同步执行队列任务
//        dispatch_sync(globalQueue, ^{
//            [self loadImage:[NSNumber numberWithInt:i]];
//        });
    }
    
    
    
    
    
    //非ARC环境请释放
    //dispatch_release(seriQueue);
}

@end
