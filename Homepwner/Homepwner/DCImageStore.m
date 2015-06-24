//
//  DCImageStore.m
//  Homepwner
//
//  Created by bokeadmin on 15/6/15.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCImageStore.h"
@interface DCImageStore ()
@property (nonatomic,strong)NSMutableDictionary *dictionary;
-(NSString*)imagePathForKey:(NSString*)key;
@end

@implementation DCImageStore

+(instancetype)sharedStore{
    static DCImageStore  *sharedStore=nil;
//    if(!sharedStore){
//        sharedStore=[[self alloc]initPrivate];
//    }
    static dispatch_once_t onceToken;
    //dispatch_once 创建线程安全的单例
    dispatch_once(&onceToken,^{sharedStore=[[self alloc]initPrivate];});
    return sharedStore;
}

-(instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[DCImageStore sharedStore]" userInfo:nil];
    return nil;
}



-(instancetype)initPrivate{
    self=[super init];
    if(self){
        _dictionary=[[NSMutableDictionary alloc]init];
        //注册为通知中心的观察者
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    return self;
}

-(void)clearCache:(NSNotification *)note{
    NSLog(@"flushing %d images out of the cache",[self.dictionary count]);
    [self.dictionary removeAllObjects];
}


-(void)setImage:(UIImage *)image forKey:(NSString *)key{
//    [self.dictionary setObject:image forKey:key];
    self.dictionary[key]=image;
    //获取保存图片的路径
    NSString *imagePath=[self imagePathForKey:key];
    //从图片中提取jpeg的数据，第二个参数标示压缩质量
    NSData *data=UIImageJPEGRepresentation(image, 0.5);
    //将数据写入文件
    [data writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key{
//    return [self.dictionary objectForKey:key];
//    return self.dictionary[key];
    UIImage *result=self.dictionary[key];
    if(!result){
        NSString *imagePath=[self imagePathForKey:key];
        result=[UIImage imageWithContentsOfFile:imagePath];
        if(result){
            self.dictionary[key]=result;
        }
        else{
            NSLog(@"error:unable to find %@",[self imagePathForKey:key]);
        }
    }
    return result;
}

-(void)deleteImageForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    NSString *imagePath=[self imagePathForKey:key];
    [[NSFileManager defaultManager]removeItemAtPath:imagePath error:nil];
}



-(NSString*)imagePathForKey:(NSString *)key{
    NSArray *documentDirectorices=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[documentDirectorices firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}
@end
