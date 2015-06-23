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
#import "DCItemStore.h"

@import MobileCoreServices;

@interface DCDetailViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>

@property(strong,nonatomic)UIPopoverController *imagePickerPopover;
//因为nameField属性指向的不是xib文件中的顶层对象，所以将引用类型设置为weak
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation DCDetailViewController

-(void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation{
    //如果是Pad则不执行任何操作
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad){
        return;
    }
    //判断设备是否处于横排方向
    if(UIInterfaceOrientationIsLandscape(orientation)){
        self.imageView.hidden=YES;
        self.cameraButton.enabled=NO;
    }
    else{
        self.imageView.hidden=NO;
        self.cameraButton.enabled=YES;
    }
    
}
#pragma mark 界面发生变化时，执行某些操作
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}
//指定初始化方法
-(instancetype)initForNewItem:(BOOL)isNew{
    self=[super initWithNibName:nil bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem=doneItem;
            
            UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem=cancelItem;
            
        }
    }
    return self;
}

-(void)save:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}
-(void)cancel:(id)sender{
    [[DCItemStore sharedStore]removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv=[[UIImageView alloc]initWithImage:nil];
    //设置UIImageView对象的内容缩放模式
    iv.contentMode=UIViewContentModeScaleAspectFit;
    //告诉自动布局系统不要将自动缩放掩码转换为约束,避免自动布局系统生成与其他约束产生冲突的NSAutoresizingMaskLayoutConstraint对象
    iv.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:iv];
    
    self.imageView=iv;
    NSDictionary *nameMap=@{@"imageView":self.imageView,
                            @"dateLabel":self.dateLabel,
                            @"toolbar":self.toolbar};
    //imageView的左边和右边与父视图的距离都是0
    NSArray *horizontalConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    //imageView的顶边与datelabel的距离是8点，底边与toolbar的距离也是8点
    NSArray *verticalConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    //将imageView垂直方向的优先级设置为比其他视图低的数值，数值为1000，表示不允许自动布局系统基于固有内容大小放大视图尺寸、缩小尺寸，小于1000则允许。
    [self.view setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.view setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark将约束添加到视图

#pragma mark检查是否存在有歧义布局的子视图
-(void)viewDidLayoutSubviews{
    for(UIView *subview in self.view.subviews){
        if([subview hasAmbiguousLayout]){
            NSLog(@"AMBIGUOUS:%@",subview);
        }
    }
}

//view将要出现时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io=[[UIApplication sharedApplication]statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
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
    if ([self.imagePickerPopover isPopoverVisible]) {
        //如果imagePickerPopover指向的是有效的UIPopoverController对象，并且该对象的视图是可见的，就关闭这个对象，并将其设为nil
        [_imagePickerPopover dismissPopoverAnimated:YES];
        _imagePickerPopover=nil;
        return;
    }
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
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    //创建UIPopoverController对象前先检查当前设备是否是ipad
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        //创建UIPopverController对象，用于显示UIImagePickerController对象
        self.imagePickerPopover=[[UIPopoverController alloc]initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate=self;
        
        //显示UIPopoverController对象，sender指向的是代表相机按钮的UIBarButtonItem对象
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else{
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
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
//            [self dismissViewControllerAnimated:YES completion:nil];
    //判断UIPopoverController对象是否存在
    if (self.imagePickerPopover) {
        //关闭UIPopoverController对象
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover=nil;
        
    }
    else{
        //关闭模态形式显示的UIImagePickerController对象
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//        }
//    }
    
    
    
    
}
#pragma mark 两种关闭键盘途径

//按下换行键关闭键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//将detail视图转为UIControl然后为其创建一个action，点击视图空白部分关闭键盘
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    //点击界面view用于检测视图缺少哪个约束
    for (UIView *subview in self.view.subviews) {
        if([subview hasAmbiguousLayout]){
            [subview exerciseAmbiguityInLayout];
        }
    }
}
//触摸屏幕其他区域可以关闭popover对象
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover=nil;
}


@end
