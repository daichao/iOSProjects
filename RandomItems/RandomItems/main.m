//
//  main.m
//  RandomItems
//
//  Created by bokeadmin on 15/5/19.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        NSLog(@"Hello, World!");
        NSMutableArray *items=[[NSMutableArray alloc]init];
//        [items addObject:@"One"];
//        [items addObject:@"Two"];
//        [items addObject:@"Three"];
//        [items insertObject:@"Zero" atIndex:0];
        
        
//        for(int i=0; i<[items count];i++){
//            NSString *item=[items objectAtIndex:i];
//            NSLog(@"%@",item);
//        }
//        for(NSString *item in items){
//            NSLog(@"%@",item);
//        }
        
//        BNRItem *item=[[BNRItem alloc]init];
//        [item setItemName:@"Red Sofa"];
//        [item setSerialNumber:@"A1B2C"];
//        [item setValueInDollars:100];
//        NSLog(@"%@%@%@%d",[item itemName],[item dateCreated],[item serialNumber],[item valueInDollars]);
//        item.itemName=@"Red Sofa";
//        item.serialNumber=@"A1B2C";
//        item.valueInDollars=100;
//        NSLog(@"%@ %@ %@ %d",item.itemName,item.dateCreated,item.serialNumber,item.valueInDollars);
//        NSLog(@"%@",item);
        
//        BNRItem *item=[[BNRItem alloc]initWithItemName:@"Red Sofa" valueInDollars:100 serialNumber:@"A1B2C"];
//        NSLog(@"%@",item);
//        
//        BNRItem *itemWithName=[[BNRItem alloc]initWithItemName:@"Blue Sofa"];
//        NSLog(@"%@",itemWithName);
//        
//        BNRItem *itemWithNoName=[[BNRItem alloc]init];
//        NSLog(@"%@",itemWithNoName);
        
        for(int i=0;i<10;i++){
            BNRItem *item=[BNRItem randomItem];
            [items addObject:item];
        }
        for(BNRItem *item in items){
            NSLog(@"%@",item);
        }
        NSLog(@"Setting items to nil...");
        items=nil;
    }
    return 0;
}
