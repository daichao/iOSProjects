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
        [self loadAllItems];
    }
    return self;
}
-(NSArray *)allItems{
    return self.privateItems;
    
}

//添加item
-(BNRItem*)createItem{
//    BNRItem *item=[BNRItem randomItem];
//    BNRItem *item=[[BNRItem alloc]init];
    double order;
    if([self.allItems count]==0){
        order=1.0;
    }else{
        order=[[self.privateItems lastObject]orderingValue]+1.0;
    }
    NSLog(@"Adding after %lu items,order=%.2f",(unsigned long)[self.privateItems count],order);
    BNRItem *item=[NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:self.context];
    item.orderingValue=order;
    [self.privateItems addObject:item];
    return item;
}

//删除item
-(void)removeItem:(BNRItem *)item{
    NSString *key=item.itemKey;
    [[DCImageStore sharedStore]deleteImageForKey:key];
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];//该方法只会移除数组所保存的那些和传入对象指针完全相同的指针。
}

//移动item
-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    if (fromIndex==toIndex) {
        return;
    }
    BNRItem *item=self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    //为移动的BNRItem对象计算新的ordervalue
    double lowerBound=0.0;
    //在数组中，该对象之前是否有其他对象
    if(toIndex>0){
        lowerBound=[self.privateItems[(toIndex-1)] orderingValue];
    }else{
        lowerBound=[self.privateItems[1] orderingValue]-2.0;
    }
    double upperBound=0.0;
    //在数组中，该对象之后是否有其他对象？
    if(toIndex<[self.privateItems count]-1){
        upperBound=[self.privateItems[(toIndex+1)]orderingValue];
    }else{
        upperBound=[self.privateItems[(toIndex-1)]orderingValue]+2.0;
    }
    double newOrderValue=(lowerBound+upperBound)/2.0;
    NSLog(@"moving to order %f",newOrderValue);
    item.orderingValue=newOrderValue;
    
}


//保存路径
-(NSString*)itemArchivePath{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[documentDirectories firstObject];
//    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
    
}
-(BOOL)saveChanges{
//    NSString *path=[self itemArchivePath];
//    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
    NSError *error;
    BOOL successful=[self.context save:&error];
    if(!successful){
        NSLog(@"Error saving:%@",[error localizedDescription]);
        
    }
    return successful;
}
-(void)loadAllItems{
    if(!self.privateItems){
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *e=[NSEntityDescription entityForName:@"BNRItem" inManagedObjectContext:self.context];
        request.entity=e;
        NSSortDescriptor *sd=[NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors=@[sd];
        NSError *error;
        NSArray *result=[self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch" format:@"Reson:%@",[error localizedDescription]];
        }
        self.privateItems=[[NSMutableArray alloc]initWithArray:result];
    }
}

-(NSArray *)allAssetTypes{
    if(!_allAssertTypes){
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *e=[NSEntityDescription entityForName:@"DCAssetType" inManagedObjectContext:self.context];
        request.entity=e;
        NSError *error=nil;
        NSArray *result=[self.context executeFetchRequest:request error:&error];
        if(!result){
            [NSException raise:@"Fetch failed" format:@"Reson:%@",[error localizedDescription]];
        }
        _allAssertTypes=[result mutableCopy];
    }
    if([_allAssertTypes count]==0){
        NSManagedObject *type;
        
        type=[NSEntityDescription insertNewObjectForEntityForName:@"DCAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssertTypes addObject:type];
        
        
        type=[NSEntityDescription insertNewObjectForEntityForName:@"DCAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssertTypes addObject:type];
        
        type=[NSEntityDescription insertNewObjectForEntityForName:@"DCAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssertTypes addObject:type];
    }
    return _allAssertTypes;
}
@end
