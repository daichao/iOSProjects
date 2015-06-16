//
//  DCImageStore.h
//  Homepwner
//
//  Created by bokeadmin on 15/6/15.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DCImageStore : NSObject
+(instancetype)sharedStore;
-(void)setImage:(UIImage *)image forKey:(NSString*)key;
-(UIImage *)imageForKey:(NSString*)key;
-(void)deleteImageForKey:(NSString*)key;
@end
