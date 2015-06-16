//
//  DCDetailViewController.m
//  Homepwner
//
//  Created by bokeadmin on 15/6/12.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCDetailViewController.h"
#import "BNRItem.h"
#import  "DCImageStore.h"
@import MobileCoreServices;

@interface DCDetailViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@end

@implementation DCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//view将要出现时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BNRItem *item=self.item;
    self.nameField.text=item.itemName;
    self.serialNumberField.text=item.serialNumber;
    self.valueField.text=[NSString stringWithFormat:@"%d",item.valueInDollars ];
    
    //创建NSDateFormatter 对象，用于将NSDate对象转化为简单的日期字符串
    static NSDateFormatter *dateFormatter=nil;
    if (!dateFormatter) {
        dateFormatter=[[NSDateFormatter alloc]init];
        dateFormatter.dateStyle=NSDateFormatterMediumStyle;
        dateFormatter.timeStyle=NSDateFormatterNoStyle;
    }
    
    //将转换后的日期字符串设置为dateLabel的标题
    self.dateLabel.text=[dateFormatter stringFromDate:item.dateCreated];
    
    
    NSString *itemKey=self.item.itemKey;
    UIImage *imageToDisplay=[[DCImageStore sharedStore]imageForKey:itemKey];
    //将得到的照片赋给UIImageView对象
    self.imageView.image=imageToDisplay;
}
//view将要消失时调用
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self.view endEditing:YES];
    BNRItem *item=self.item;
    item.itemName=self.nameField.text;
    item.serialNumber=self.serialNumberField.text;
    item.valueInDollars=[self.valueField.text intValue];
    
    
    
}
-(void)setItem:(BNRItem *)item{
    _item=item;
    self.navigationItem.title=_item.itemName;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    NSArray *availableTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//返回一个数组，其中包含2个对象image和moive
    /*
     如果限制只能拍摄视频
     NSArray *availableTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
     if([availableTypes containsObject:(__bridge NSString *)kUTTypeMoive]){
     [imagePicker setMediaTypes:@[(__bridge NSString *)kUTTypeMoive]];
     */
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.mediaTypes=availableTypes;//加上这个就可以摄像
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate=self;
        [imagePicker setEditing:YES animated:YES];
    }else{
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate=self;
    //以模态的形式显示UIImagePickerController对象
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    NSURL *mediaURL=info[UIImagePickerControllerMediaURL];
//    if(mediaURL){
//        //确认设备是否支持视频
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([mediaURL path])) {
//            //将视频存入相册
//            UISaveVideoAtPathToSavedPhotosAlbum([mediaURL path], nil, nil, nil);
//            //删除临时目录下的视频
//            [[NSFileManager defaultManager]removeItemAtPath:[mediaURL path] error:nil];
//        }
//        else{
            //通过info字典获取选择的照片
            UIImage *image=info[UIImagePickerControllerOriginalImage];
            //以itemkey为键，将照片存入DCImageStore对象
            [[DCImageStore sharedStore]setImage:image forKey:self.item.itemKey];
            self.imageView.image=image;
            //关闭uiimagepickercontroller对象
            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }
    
    
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}


@end
