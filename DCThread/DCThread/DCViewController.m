//
//  DCViewController.m
//  DCThread
//
//  Created by bokeadmin on 15/6/9.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCViewController.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10
#define IMAGE_COUNT 9

@interface DCViewController (){
    NSMutableArray *_imageViews;
    NSCondition *_condition;
}

@end

@implementation DCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}


#pragma mark 内部私有方法
#pragma mark界面布局
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

    UIButton *btnLoad=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLoad.frame=CGRectMake(50, 500, 100, 25);
    [btnLoad setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnLoad addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoad];
    
    UIButton *btnCreate=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCreate.frame=CGRectMake(160, 500, 100, 25);
    [btnCreate setTitle:@"创建图片" forState:UIControlStateNormal];
    [btnCreate addTarget:self action:@selector(createImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCreate];
    
    
    //创建图片链接
    _imageNames=[NSMutableArray array];
    
    //初始化锁对象
    _condition=[[NSCondition alloc]init];
    
    _currentIndex=0;
    
}

#pragma mark 创建图片
-(void)createImageName{
    [_condition lock];
    if(_imageNames.count>0){
        NSLog(@"createImageName wait,current:%i",_currentIndex);
        [_condition wait];
    }
    else{
        NSLog(@"createImageName work,current:%i",_currentIndex);
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",_currentIndex++]];
         [_condition signal];
    }
    [_condition unlock];
}

#pragma mark 请求图片数据
-(NSData *)requestData:(int)index{
    NSData *data;
    NSString *name;
    name=[_imageNames lastObject];
    [_imageNames removeObject:name];
    if (name) {
        NSURL *url=[NSURL URLWithString:name];
        data=[NSData dataWithContentsOfURL:url];
    }
    return data;
}
#pragma mark 加载图片并将图片显示到界面
-(void)loadAnUpdateImageWithIndex:(int)index{
    NSData *data=[self requestData:index];
    dispatch_queue_t mainQueue=dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        UIImage *image=[UIImage imageWithData:data];
        UIImageView *imageView=_imageViews[index];
        imageView.image=image;
    });
}




#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i=[index intValue];
    
}
@end
