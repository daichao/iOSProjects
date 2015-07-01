//
//  DCItemStore.m
//  Homepwner
//
//  Created by daichao on 15/6/11.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCItemStore.h"
#import "BNRItem.h"
#import "DCImageStore.h"
@import CoreData;
/*
 在类扩展中声明属性或方法，则只有这个类才能访问这个属性和方法，别的类无法访问
 */
@interface DCItemStore()
@property (nonatomic)NSMutableArray *privateItems;
@property(nonatomic,strong)NSMutableArray *allAssertTypes;
@property(nonatomic,strong)NSManagedObjectContext *context;
@property(nonatomic,strong)NSManagedObjectModel *model;

@end
@implementation DCItemStore

+(instancetype)sharedStore{
    static DCItemStore *sharedStore=nil;
//    if(!sharedStore){
//        sharedStore=[[self alloc]initPrivate];
//    }
    //线程安全的单例
    static dispatch_once_t once_token;
    dispatch_once(&once_token,^{sharedStore=[[self alloc]initPrivate];});
    return sharedStore;
}

-(instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use+[DCItemStore sharedStore]" userInfo:nil];
}

-(instancetype)initPrivate{
    self=[super init];
    if(self){
//        _privateItems=[[NSMutableArray alloc]init];
//        NSString *path=[self itemArchivePath];
//        _privateItems=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
//        if(!_privateItems){
//            _privateItems=[[NSMutableArray alloc]init];
//        }
        //读取Homepwner.xcdatamodeld
        _model=[NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model];
        //设置SQLite文件路径
        NSString *path=[self itemArchivePath];
        NSURL *storeURL=[NSURL fileURLWithPath:path];
        NSError *error=nil;
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        //创建NSManagedObjectContext对象
        _context=[[NSManagedObjectContext alloc]init];
        _context.persistentStoreCoordinator=psc;
    }
    return self;
}
-(NSArray *)allItems{
    return self.privateItems;
    
}
-(BNRItem*)createItem{
//    BNRItem *item=[BNRItem randomItem];
    BNRItem *item=[[BNRItem alloc]init];
    [self.privateItems addObject:item];
    return item;
}
-(void)removeItem:(BNRItem *)item{
    NSString *key=item.itemKey;
    [[DCImageStore sharedStore]deleteImageForKey:key];
    [self.privateItems removeObjectIdenticalTo:item];//该方法只会移除数组所保存的那些和传入对象指针完全相同的指针。
}
-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    if (fromIndex==toIndex) {
        return;
    }
    BNRItem *item=self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

-(NSString*)itemArchivePath{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[documentDirectories firstObject];
//    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
    
}
-(BOOL)saveChanges{
    NSString *path=[self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}
@end
