//
//  UserInfoViewCtrl.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/29.
//

#import "UserInfoViewCtrl.h"
#import "CommonButton.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"
#import "UIFont+CustomFont.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "PopViewController.h"
#import "VideoViewController.h"
#import "TZImagePickerController.h"
#import "UIImage+FixOritention.h"
#import <SDWebImage/SDWebImage.h>

@interface UserInfoViewCtrl ()<TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView * headImg;
@property (nonatomic, strong) UILabel * clickLab;
@property (nonatomic, strong) UIButton * headBtn;

@property (nonatomic, strong) UITextField * nickNameTF;
@property (nonatomic, strong) UITextField * nameTF;
@property (nonatomic, strong) UITextField * phoneTF;

@property (nonatomic, strong) CommonButton * saveBtn;
@property (nonatomic, strong) User * user;

@property (nonatomic, strong) UIImage * selectImg;
@end

@implementation UserInfoViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.midTitle = @"基础信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headImg = [[UIImageView alloc] initWithFrame:CGRectMake( (self.view.width - 96)/2,self.navbarView.bottom + 32, 96, 96)];
    self.headImg.image = [UIImage imageNamed:@"defaultHead"];
    self.headImg.layer.cornerRadius = 48.0;
    self.headImg.backgroundColor = [UIColor bgWhiteColor];
    self.headImg.layer.masksToBounds = YES;
    [self.view addSubview:self.headImg];
    
    self.clickLab = [[UILabel alloc] initWithFrame:CGRectMake(self.headImg.left, self.headImg.bottom + 12, self.headImg.width, 20)];
    self.clickLab.textColor = [UIColor tintColor];
    self.clickLab.font = [UIFont tipFont];
    self.clickLab.text = @"点击修改头像";
    self.clickLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.clickLab];
    
    self.headBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.headImg.left, self.headImg.top, self.headImg.width, (self.clickLab.bottom - self.headImg.top))];
    [self.headBtn addTarget:self action:@selector(headBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.headBtn];
    
    UIView * inputView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.height - 48*3)/2, self.view.width, 48*3)];
    [self.view addSubview:inputView];
    
    float leftW = 72;
    
    UIView * nickView = [[UIView alloc] initWithFrame:CGRectMake(0,0, inputView.width, 48)];
    [inputView addSubview:nickView];
    UILabel * nickLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 12, leftW, 24)];;
    nickLab.text = @"昵称";
    nickLab.font = [UIFont textFont];
    nickLab.textColor = [UIColor darkTextColor];
    [nickView addSubview:nickLab];
    self.nickNameTF = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, nickView.width - 112-24, 24)];
    self.nickNameTF.placeholder = @"请输入昵称";
    self.nickNameTF.font = [UIFont textFont];
    self.nickNameTF.textColor = [UIColor textColor];
    [nickView addSubview:self.nickNameTF];
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(16, 47, nickView.width-2*16, 0.5)];
    line1.backgroundColor = [UIColor lineColor];
    [nickView addSubview:line1];
    
    UIView * nameView = [[UIView alloc] initWithFrame:CGRectMake(0,48, inputView.width, 48)];
    [inputView addSubview:nameView];
    UILabel * nameLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 12, leftW, 24)];;
    nameLab.text = @"姓名";
    nameLab.font = [UIFont textFont];
    nameLab.textColor = [UIColor darkTextColor];
    [nameView addSubview:nameLab];
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, nameView.width - 112-24, 24)];
    self.nameTF.placeholder = @"请输入姓名";
    self.nameTF.font = [UIFont textFont];
    self.nameTF.textColor = [UIColor textColor];
    [nameView addSubview:self.nameTF];
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(16, 47, nameView.width-2*16, 0.5)];
    line2.backgroundColor = [UIColor lineColor];
    [nameView addSubview:line2];
    
    UIView * phoneView = [[UIView alloc] initWithFrame:CGRectMake(0,48*2, inputView.width, 48)];
    [inputView addSubview:phoneView];
    UILabel * phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 12, leftW, 24)];;
    phoneLab.text = @"联系方式";
    phoneLab.font = [UIFont textFont];
    phoneLab.textColor = [UIColor darkTextColor];
    [phoneView addSubview:phoneLab];
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, phoneView.width - 112-24, 24)];
    self.phoneTF.placeholder = @"请输入联系方式";
    self.phoneTF.font = [UIFont textFont];
    self.phoneTF.textColor = [UIColor textColor];
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:self.phoneTF];
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(16, 47, phoneView.width-2*16, 0.5)];
    line3.backgroundColor = [UIColor lineColor];
    [phoneView addSubview:line3];
    
    self.saveBtn = [[CommonButton alloc] initWithFrame:CGRectMake(24, self.view.bottom - 96 - 44, self.view.width - 2*24, 44) title:@"保存"];
    [self.saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    
    self.user = [NetWorkAPIManager defaultManager].curUser;
}

- (void)setUser:(User *)user
{
    _user = user;
    
    self.nickNameTF.text = user.nickname;
    self.nameTF.text = user.name;
    self.phoneTF.text = user.cellphone;
    if (user.avartar.length > 0) {
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:user.avartar]];
    }else {
        self.headImg.image = [UIImage imageNamed:@"defaultHead"];
    }
}

- (void)headBtnClicked
{
    [CommonTool resign];
    NSString * item1 = @"拍照";
    NSString * item2 = @"从相册选择";
    PopViewController * popCtrl = [[PopViewController alloc] initWithTitle:@"选择头像" Data:@[item1, item2]];
    __weak typeof(self) weakSelf = self;
    popCtrl.selectBlock = ^(NSInteger index, NSString * _Nonnull string) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([string isEqualToString:item1]) {
            [strongSelf takePhoto];
        }else if ([string isEqualToString:item2]) {
            [strongSelf selectPhoto];
        }
    };
    [popCtrl showOn:self];
}

- (void)saveBtnClicked
{
    [CommonTool resign];
    
    if (self.selectImg) {
        [self handleImageToOSS:self.selectImg];
    }else {
        [self saveUserInfo];
    }
}

- (void)saveUserInfo
{
    self.user.name = self.nameTF.text;
    self.user.nickname = self.nickNameTF.text;
    self.user.cellphone = self.phoneTF.text;
    
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonPUT:@"/enocolor/client/security/user" parm:[self.user convertToDictionary] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [CommonTool showHint:@"保存成功"];
        [strongSelf getUserInfo];
   
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

- (void)getUserInfo
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] getUserInfosuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.user = [NetWorkAPIManager defaultManager].curUser;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
    
}

//拍摄照片和视频
- (void)takePhoto
{
    __weak typeof(self) weakSelf = self;
    VideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"VideoViewController" owner:nil options:nil].lastObject;
    ctrl.HSeconds = 15;//设置可录制最长时间
    ctrl.takeBlock = ^(PHAsset *asset) {
        __strong typeof(self) strongSelf = weakSelf;
        
        PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionOriginal;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        options.networkAccessAllowed = YES;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(320, 480) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            __strong typeof(self) strongSelf = weakSelf;
            __weak typeof(self) weakSelf2 = strongSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf2 = weakSelf2;
                UIImage * image = [result fixOrientation];
                strongSelf2.headImg.image = image;
                strongSelf2.selectImg = image;
            });
            
        }];
        
    };

    ctrl.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    ctrl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:ctrl animated:YES completion:NULL];
    
}



-(void)selectPhoto
{
    [TZImagePickerConfig sharedInstance];
    
    TZImagePickerController * imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.allowPreview = NO;
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowTakePicture = NO;
    imagePicker.allowTakeVideo = NO;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.allowCrop = NO;
    imagePicker.allowPickingVideo = NO;
    imagePicker.maxImagesCount = 1;
    
    imagePicker.photoDefImage = [UIImage imageNamed:@"clear"];
    imagePicker.photoSelImage = [UIImage imageNamed:@"photo_sel"];
    imagePicker.naviBgColor = [UIColor whiteColor];
    imagePicker.naviTitleColor = [UIColor darkTextColor];
    imagePicker.naviTitleFont = [UIFont boldTitleFont];
    imagePicker.barItemTextColor = [UIColor tintColor];
    imagePicker.barItemTextFont = [UIFont boldTextFont];
    imagePicker.oKButtonTitleColorNormal = [UIColor tintColor];
    imagePicker.oKButtonTitleColorDisabled = [UIColor greyColor];
    imagePicker.iconThemeColor = [UIColor tintColor];
    
    imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    UIImage * image = photos.firstObject;
    self.headImg.image = image;
    self.selectImg = image;
}

-(void)handleImageToOSS:(UIImage *)image
{
    if ([[NetWorkAPIManager defaultManager].ossSignature isExpired]) {
        
        __weak typeof(self) weakSelf = self;
        [[NetWorkAPIManager defaultManager] getOSSSignatureSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf uploadImageToOss:image];
            
        } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CommonTool showHint:@"获取签名失败"];
        }];
    }else {
        [self uploadImageToOss:image];
    }
    
}

-(void)uploadImageToOss:(UIImage *)image
{
    __weak typeof(self) weakSelf = self;
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    NSString * key = [NSString stringWithFormat:@"%@/%@.jpeg",[NetWorkAPIManager defaultManager].ossSignature.dir,[CommonTool getNowTimestamp]];
    NSMutableDictionary * parm = [NSMutableDictionary dictionaryWithDictionary:[[NetWorkAPIManager defaultManager].ossSignature convertToDictionary]];
    [parm setValue:key forKey:@"key"];
    [[NetWorkAPIManager defaultManager] uploadData:imgData signature:parm success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        NSString * path = [NSString stringWithFormat:@"%@/%@",[NetWorkAPIManager defaultManager].ossSignature.host,key];
        
        strongSelf.user.avartar = path;
        [strongSelf saveUserInfo];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
    
}


@end
