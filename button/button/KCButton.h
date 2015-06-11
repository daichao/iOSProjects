//
//  KCButton.h
//  button
//
//  Created by daichao on 15/5/30.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  KCButton;
@protocol KCButtonDelegate<NSObject>
@required
-(void)onClick:(KCButton*)button;
@optional
-(void)onMouseover:(KCButton *)button;
-(void)onMouseout:(KCButton *)button;
@end

@interface KCButton : NSObject


@end