//
//  ViewController.m
//  HggIssueMessage
//
//  Created by zww on 2017/8/31.
//  Copyright © 2017年 zww. All rights reserved.
//

#import "ViewController.h"
#import "HggNumTextfieldView.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"

#import "RedioView.h"

#import "AFNetworking.h"
#import "HNEmoticonHelper.h"
#import "ContractViewController.h"
@interface ViewController () <TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
}

@property (nonatomic, strong) HggNumTextfieldView *numTextField;
@property (nonatomic, strong) HggNumTextfieldView *numTextField1;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic,strong)RedioView *redioView;
@property (nonatomic,strong)NSString *string;
@end

@implementation ViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
      //  UIBarButtonItem *tzBarItem, *BarItem;
//        if (iOS9Later) {
//            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
//            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
//        } else {
//            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
//            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
//        }
//        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
//        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    self.title = @"发布消息";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    //  manager.requestSerializer.timeoutInterval = timeOut;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //[manager.requestSerializer setValue:@"PHPSESSID=tia7ltc7k7erhhhufe511ab8j2" forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    //  [manager.requestSerializer setValue:@"PHPSESSID=tia7ltc7k7erhhhufe511ab8j2" forHTTPHeaderField:@"Cookie"];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //
    //
    //
    //
    //2.上传文件,在这里我们还要求传别的参数，用字典保存一下，不需要的童鞋可以省略此步骤
    // NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:_fireID,@"id",_longitude,@"longitude",_latitude,@"latitude", nil];
    // NSString *urlString = @"http://www.dakahao.cn/AppLogin/test";
    NSString *urlString  =@"http://www.dakahao.cn/AppLogin/index";
    NSString *phone = @"17682106880";
    NSString *pass = @"123456";
//    NSString *content  =self.string;
//    NSLog(@"%@",self.string);
    
 
    
    NSInteger time = [[HNEmoticonHelper getNowTimeTimestamp]intValue];
    NSString *name = [NSString stringWithFormat:@"%@%@%@%@%@",[HNEmoticonHelper md5:@"$dkh"],[HNEmoticonHelper md5:pass],[HNEmoticonHelper md5:phone],[HNEmoticonHelper md5:[NSString stringWithFormat:@"%ld",(long)time]],[HNEmoticonHelper md5:@"$wts"]];
    NSString *token =[HNEmoticonHelper md5:name];
    
    // NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    // [dic setValue:fullPath forKey:@"cover_img"];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:pass forKey:@"pass"];
    [dic setValue:token forKey:@"token"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)time] forKey:@"time"];
   // [dic setValue:token forKey:@"token"];
    
    [manager POST:urlString parameters:dic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             //      进度条
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //       post请求成功后的操作
             NSLog(@"post请求成功＝＝＝＝%@",responseObject);
             NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"resultDictionary: %@", resultDictionary);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //       请求失败后的操作
             NSLog(@"请求失败＝＝＝＝%@",error);
         }];
    

    
    
    
    
    
    
 
    
    //调用
  
    self.numTextField = [[HggNumTextfieldView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height)];
    __block typeof(self) bself = self;
    self.numTextField.buttonAction = ^(NSString *string){
        bself.string = string;
    };
    [self.view addSubview:self.numTextField];
    
      [self configCollectionView];
    
//    RedioView * redioView = [[RedioView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 70)];
//
//    redioView.block = ^(RedioButton *button){
//        NSLog(@"点击的%d",(int)button.tag);
//        if (button.tag == 0) {
//            NSLog(@"点击的%d",(int)button.tag);
//            self.numTextField = [[HggNumTextfieldView alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
//            [self.view addSubview:self.numTextField];
//             [self configCollectionView];
//            //初始化十足
//            _selectedPhotos = [NSMutableArray array];
//            _selectedAssets = [NSMutableArray array];
//        }else if (button.tag ==1){
//            NSLog(@"点击的%d",(int)button.tag);
//            self.numTextField = [[HggNumTextfieldView alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
//            [self.view addSubview:self.numTextField];
//              [self configCollectionView];
//            //初始化十足
//            _selectedPhotos = [NSMutableArray array];
//            _selectedAssets = [NSMutableArray array];
//        }else{
//             NSLog(@"点击的%d",(int)button.tag);
//            self.numTextField = [[HggNumTextfieldView alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
//            [self.view addSubview:self.numTextField];
//        }
//    };
//    self.redioView = redioView;
//    redioView.titleArray = @[@"视频",@"趣图",@"段子"];
//    [self.view addSubview:redioView];
    
 //[self configCollectionView];
   
//
    
   
}
//-(RedioView *)redioView{
//    if (!_redioView) {
//        _redioView = [[RedioView alloc] initWithFrame:CGRectMake(0, 100, 375, 200)];
//    }
//    return _redioView;
//}

- (void)configCollectionView {
 
     //添加一个小头
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(20, self.numTextField.numHight + 20, 100, 15);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"图片选择";
    titleLabel.textColor = [UIColor redColor];
    [self.view addSubview:titleLabel];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    button.frame = CGRectMake(120, self.numTextField.numHight, 140, 40);
    [button setTitle:@"获取联系方式" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    // _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
    
    _itemWH = (self.view.tz_width - 30 - 3 * _margin) / 4;
    
    
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, self.numTextField.numHight + 20 + 25, self.view.tz_width - 2 * 15, 400) collectionViewLayout:_layout];
    _layout.panGestureRecognizerEnable = NO;
    CGFloat rgb = 244 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    //    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
 
}
-(void)buttonClick:(UIButton *)button{
    ContractViewController *vc = [[ContractViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        //是否谈出来选择
        BOOL showSheet = YES;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        } else {
            [self pickPhotoButtonClick:nil];
        }
    } else { // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        // imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            _layout.itemCount = _selectedPhotos.count;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
    }
}

#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (IBAction)pickPhotoButtonClick:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    // imagePickerVc.allowTakePicture = NO; // 隐藏拍照按钮
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"%@.....%@",photos,assets);
        //读取图片数据，设置压缩系数为0.5.
       // NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
        //1.创建管理者对象
        
        
//        NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject: cookiesData forKey:@"Cookie"];
//        [defaults synchronize];
//
//
//        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"]];
//        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie * cookie in cookies)
//        {
//            [cookieStorage setCookie: cookie];
//
//        }
     
            
            
          
        
    
        
        
     
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        //  manager.requestSerializer.timeoutInterval = timeOut;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        //[manager.requestSerializer setValue:@"PHPSESSID=tia7ltc7k7erhhhufe511ab8j2" forHTTPHeaderField:@"Cookie"];
        [manager.requestSerializer setHTTPShouldHandleCookies:YES];
       //  [manager.requestSerializer setValue:@"PHPSESSID=tia7ltc7k7erhhhufe511ab8j2" forHTTPHeaderField:@"Cookie"];
        //接收类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //
        //
        //
        //
        //2.上传文件,在这里我们还要求传别的参数，用字典保存一下，不需要的童鞋可以省略此步骤
        // NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:_fireID,@"id",_longitude,@"longitude",_latitude,@"latitude", nil];
       // NSString *urlString = @"http://www.dakahao.cn/AppLogin/test";
        NSString *urlString  =@"http://www.dakahao.cn/AppIssue/message_issue_img";
        NSString *type = @"5";
        NSString *addr = @"340000";
        NSString *content  =self.string;
        NSLog(@"%@",self.string);
        
        
        
//        NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:urlString]];
//        NSMutableArray<NSDictionary *> *propertiesList = [[NSMutableArray alloc] init];
//        [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSMutableDictionary *properties = [[cookie properties] mutableCopy];
//            //将cookie过期时间设置为一年后
//            NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12];
//            properties[NSHTTPCookieExpires] = expiresDate;
//            //下面一行是关键,删除Cookies的discard字段，应用退出，会话结束的时候继续保留Cookies
//            [properties removeObjectForKey:NSHTTPCookieDiscard];
//            //重新设置改动后的Cookies
//            [cookieStorage setCookie:[NSHTTPCookie cookieWithProperties:properties]];
//
//        }];
//
        
        NSInteger time = [[HNEmoticonHelper getNowTimeTimestamp]intValue];
        NSString *name = [NSString stringWithFormat:@"%@%@%@%@%@%@",[HNEmoticonHelper md5:@"$dkh"],[HNEmoticonHelper md5:addr],[HNEmoticonHelper md5:content],[HNEmoticonHelper md5:[NSString stringWithFormat:@"%ld",(long)time]],[HNEmoticonHelper md5:type],[HNEmoticonHelper md5:@"$wts"]];
        NSString *token =[HNEmoticonHelper md5:name];
        
        // NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        // [dic setValue:fullPath forKey:@"cover_img"];
        [dic setValue:type forKey:@"type"];
        [dic setValue:addr forKey:@"addr"];
        [dic setValue:content forKey:@"content"];
        [dic setValue:[NSString stringWithFormat:@"%ld",(long)time] forKey:@"time"];
        [dic setValue:token forKey:@"token"];
        
        // post请求
        [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            for (int i = 0; i < photos.count; i ++) {
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i+1];
                UIImage *image = photos[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
           //     NSLog(@"%@",fileName);
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"img[]"] fileName:fileName mimeType:@"image/png"];
            //    NSLog(@"%@",[NSString stringWithFormat:@"img%d",i+1]);
            }
            
    //        NSLog(@"%@",formData);
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            //打印下上传进度
            NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功
            //        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //        NSLog(@"%@", responseString);
            
            // Data 转成 字典 其中responseObject为返回的data数据
//            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlString]];
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", responseString);
//            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Cookie"];
            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"resultDictionary: %@", resultDictionary);
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发表"
                                                                           message:[resultDictionary objectForKey:@"data"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      NSLog(@"action = %@", action);
                                                                  }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     //响应事件
                                                                     NSLog(@"action = %@", action);
                                                                 }];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //请求失败
            NSLog(@"请求失败：%@",error);
        }];
        
        
        
        
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
//     imagePickerVc.allowPickingVideo = YES;
//     imagePickerVc.allowPickingImage = NO;
//     imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
//     NSLog(@"cancel");
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;
    // open this code to send video / 打开这段代码发送视频
     [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
     }];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        //选择图片
        [self pickPhotoButtonClick:nil];
    }
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}
// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    //    __weak typeof(self) weakSelf = self;
    //    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
    //        weakSelf.location = location;
    //    } failureBlock:^(NSError *error) {
    //        weakSelf.location = nil;
    //    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        //        [TZImageManager manager] savePhotoWithImage:<#(UIImage *)#> completion:<#^(void)completion#>
        
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
               // BOOL allowCrop = YES;
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        //                        }
                    }];
                }];
            }
        }];
    }
}
- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

@end
