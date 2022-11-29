//
//  VersionUpdateViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/10/15.
//

#import "VersionUpdateViewController.h"
#import "UIView+Hint.h"
#import "NetWorkAPIManager.h"

@interface VersionUpdateViewController ()
@property (copy, nonatomic)NSString * version;
@property (copy, nonatomic)NSString * releaseNotes;

@property (strong, nonatomic) IBOutlet UIView *detaiView;
@property (strong, nonatomic) IBOutlet UILabel *notesLab;
@property (strong, nonatomic) IBOutlet UIButton *updateBtn;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;


@end

@implementation VersionUpdateViewController

-(instancetype)initWithNotes:(NSString*)releaseNotes version:(NSString *)version
{
    self = [super init];
    if (self) {
        self.version = version;
        self.releaseNotes = releaseNotes;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.notesLab.text = self.releaseNotes;
    [self.notesLab sizeToFit];
    
    [self.detaiView setBottomLRCornor:8.0];

    self.updateBtn.layer.cornerRadius = 4;
    self.updateBtn.layer.masksToBounds = YES;

    [self getVersionConfig];
}

-(void)getVersionConfig
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] getVersionConfigSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = responseObject;
        NSString * version = [dic objectForKey:@"version"];
        BOOL isForceUpdate = [dic objectForKey:@"isForceUpdate"];
        
        __strong typeof(self) strongSelf = weakSelf;
        __weak typeof(self) weakSelf2 = strongSelf;
        
        if ([version isEqualToString:weakSelf.version]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf2 = weakSelf2;
                strongSelf2.closeBtn.hidden = isForceUpdate;
            });
        }
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.detaiView setBottomLRCornor:8.0];
}

- (IBAction)updateBtnClicked:(id)sender {
    
    __weak VersionUpdateViewController * weakself = self;
    
    NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id1580542245?ls=1&mt=8"]];

    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        [weakself dismiss];
    }];
}


- (IBAction)closeBtnClicked:(id)sender {
    
    [self dismiss];
}


-(void)showOn:(UIViewController *)viewCtrl
{
    self.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [viewCtrl presentViewController:self animated:NO completion:NULL];
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
