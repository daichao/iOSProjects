//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRItem.h"

@interface BNRItem ()

@property (nonatomic, strong) NSDate *dateCreated;

@end

@implementation BNRItem

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    // Create an array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    // Note that NSInteger is not an object, but a type definition
    // for "unsigned long"
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                                randomAdjectiveList[adjectiveIndex],
                                randomNounList[nounIndex]];
    int randomValue = rand() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                        '0' + rand() % 10,
                                        'A' + rand() % 26,
                                        '0' + rand() % 10,
                                        'A' + rand() % 26,
                                        '0' + rand() % 10];
    BNRItem *newItem =
        [[self alloc] initWithItemName:randomName
                        valueInDollars:randomValue
                          serialNumber:randomSerialNumber];
    return newItem;
}

- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        self.itemName = name;
        self.serialNumber = sNumber;
        self.valueInDollars = value;
        self.dateCreated = [[NSDate alloc] init];
        NSUUID *uuid=[[NSUUID alloc]init];
        NSString *key=[uuid UUIDString];
        _itemKey=key;
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)init {
    return [self initWithItemName:@"Item"
                   valueInDollars:0
                     serialNumber:@""];
}

- (NSString *)description
{
    NSString *descriptionString =
        [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                            self.itemName,
                            self.serialNumber,
                            self.valueInDollars,
                            self.dateCreated];
    return descriptionString;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}
#pragma mark固化编码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    
}
#pragma mark解固编码
-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self=[super init];
    if(self){
        _itemName=[aDecoder decodeObjectForKey:@"itemName"];
        _itemKey=[aDecoder decodeObjectForKey:@"itemKey"];
        _serialNumber=[aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated=[aDecoder decodeObjectForKey:@"dateCreated"];
        _valueInDollars=[aDecoder decodeIntForKey:@"valueInDollars"];
        _thumbnail=[aDecoder decodeObjectForKey:@"thumbnail"];
        
    }
    return self;
}

#pragma mark创建缩放图片
-(void)setThumbnailFromImage:(UIImage *)image{
    CGSize origImageSize=image.size;
    //缩略图的大小
    CGRect newRect=CGRectMake(0, 0, 40, 40);
    //确定缩放倍数并保持宽高比不变
    float ratio=MAX(newRect.size.width/origImageSize.width,newRect.size.height/origImageSize.height);
    //根据当前设备的屏幕scaling factor创建透明的位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    //创建标示圆角矩形的UIBezierPath对象
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    //根据UIBezierPath对象截取图形上下文
    [path addClip];
    //让图片在缩略图绘制范围内居中
    CGRect projectRect;
    projectRect.size.width=ratio*origImageSize.width;
    projectRect.size.height=ratio*origImageSize.height;
    projectRect.origin.x=(newRect.size.width-projectRect.size.width)/2.0;
    projectRect.origin.y=(newRect.size.height-projectRect.size.height)/2.0;
    
    //在上下文中绘制图片
    [image drawInRect:projectRect];
    
    //通过图形上下文得到UIImage对象，并将其赋给thumbnail属性
    UIImage *smallImage=UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail=smallImage;
    
    //清理图形上下文
    UIGraphicsEndImageContext();
}
@end
