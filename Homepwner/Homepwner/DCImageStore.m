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
@end

@implementation DCImageStore

+(instancetype)sharedStore{
    static DCImageStore  *sharedStore=nil;
    if(!sharedStore){
        sharedStore=[[self alloc]initPrivate];
    }
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
    }
    return self;
}
-(void)setImage:(UIImage *)image forKey:(NSString *)key{
//    [self.dictionary setObject:image forKey:key];
    self.dictionary[key]=image;
}

-(UIImage *)imageForKey:(NSString *)key{
//    return [self.dictionary objectForKey:key];
    return self.dictionary[key];
}

-(void)deleteImageForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
