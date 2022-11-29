//
//  PlayerViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/7/23.
// 视频全屏播放页面

#import "PlayerViewController.h"
#import "LineProgressView.h"
#import "AVPlayerView.h"
#import "VideoPlayer.h"
#import "AppDelegate.h"
#import "CommonTool.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+CustomColor.h"
//#import "LayoutTagCommentEditView.h"
#import "UIView+Hint.h"

@interface PlayerViewController ()<VideoPlayerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *coverView;
@property (strong, nonatomic) IBOutlet UIButton *volumeBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIView *navBar;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) IBOutlet UIView * toolVIew;
@property (strong, nonatomic) IBOutlet UIButton *playpauseBtn;
@property (strong, nonatomic) IBOutlet UIButton *fullscreenBtn;
@property (strong, nonatomic) IBOutlet UILabel *currentTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLab;

@property (strong, nonatomic) IBOutlet LineProgressView * progressView;
//视频播放
//@property (strong, nonatomic) AVPlayerView * playerView;
@property (strong, nonatomic) VideoPlayer * playerView;

//@property(nonatomic,strong) LayoutTagCommentEditView * editView;

@property (copy, nonatomic) NSString * name;
@property (strong, nonatomic) NSURL * videoUrl;
@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) BOOL isMute;
@property (assign, nonatomic) BOOL isFull;
@property (assign, nonatomic) BOOL showToolBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navbarTop;

@property (strong, nonatomic) NSTimer * timer;

//@property(nonatomic,strong) IBOutlet LayoutTagCommentEditView * tagview;
@property(nonatomic,assign) BOOL editTag;
@property(nonatomic,assign) BOOL editComment;
@property(nonatomic,copy) NSString * tagString;
@property(nonatomic,copy) NSString * commentString;
//@property(nonatomic,assign) TagType tagType;
@property(nonatomic,assign) BOOL hasModify;

@property(nonatomic,assign) BOOL firstAppear;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagViewWidthConstraint;

@end

@implementation PlayerViewController

-(instancetype)initWithUrl:(NSURL *)url
{
    self = [self init];
    if (self) {
        _videoUrl = url;
        self.editTag = NO;
        self.editComment = NO;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

-(instancetype)initWithUrl:(NSURL *)url name:(NSString *)name
{
    self = [self init];
    if (self) {
        self.name = name;
        _videoUrl = url;
        self.editTag = NO;
        self.editComment = NO;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

//-(instancetype)initWithUrl:(NSURL*)url tag:(NSString*)tagString tagType:(TagType)tagType
//{
//    self = [self init];
//    if (self) {
//        _videoUrl = url;
//        self.editTag = YES;
//        self.editComment = NO;
//        self.tagString = tagString;
//        self.tagType = tagType;
//    }
//    return self;
//}
//
//-(instancetype)initWithUrl:(NSURL*)url tag:(NSString*)tagString tagType:(TagType)tagType comment:(NSString *)comment
//{
//    self = [self init];
//    if (self) {
//        _videoUrl = url;
//        self.editTag = TRUE;
//        self.editComment = YES;
//        self.tagString = tagString;
//        self.tagType = tagType;
//        self.commentString = comment;
//    }
//    return self;
//}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.enabled = YES;
        self.editTag = NO;
        self.editComment = NO;
        self.firstAppear = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbarTop.constant = [CommonTool statusbarH];

    if (!self.playerView) {
        self.playerView = [VideoPlayer player];
        [self.playerView layoutVideoPlayerwithurl:_videoUrl.absoluteString onView:self.coverView];
        self.playerView.delegate = self;
    }
    self.isPlaying = NO;
    self.isMute = NO;
    self.isFull = NO;
    self.showToolBar = YES;

//    self.editView = [[LayoutTagCommentEditView alloc] initWithFrame:CGRectMake(0,self.toolVIew.frame.origin.y - 108-24, self.view.frame.size.width, 108)];
//    self.editView.backgroundColor = [UIColor clearColor];
//    self.editView.attachCtrl = self;
//    __weak typeof(self) weakSelf = self;
//    self.editView.tagChangedBlock = ^(NSString * tag) {
//        __strong typeof(self) strongSelf = weakSelf;
//        strongSelf.tagString = tag;
//        strongSelf.hasModify = YES;
//    };
//    
//    self.editView.commentChangedBlock = ^(NSString * comment) {
//        __strong typeof(self) strongSelf = weakSelf;
//        strongSelf.commentString = comment;
//        strongSelf.hasModify = YES;
//    };
//    
//    self.editView.showTag = self.editTag;
//    self.editView.tagType = self.tagType;
//    self.editView.showComment = self.editComment;
//    self.editView.tagString = self.tagString;
//    self.editView.commentString = self.commentString;
//    self.editView.placeholder = @"添加备注(限50字)...";
//    [self.view addSubview:self.editView];
    
    self.titleLab.text = self.name;

    self.enabled = _enabled;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self addGesture];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];//设置当按“静音”或者锁屏不会静音
    
//    [self.view layoutSubviews];
//    self.editView.frame = CGRectMake(0,self.toolVIew.frame.origin.y - 108-24, self.view.frame.size.width, 108);
//    [self.playerView relayout];
}

-(void)swipeHandler
{
    [self dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.editView.frame = CGRectMake(0,self.toolVIew.frame.origin.y - 108-24, self.view.frame.size.width, 108);
    [self.playerView relayout];
//    [self setLandscapeRight];
    [self addNotify];
    
//    [self addTimer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self removeNotify];
    [self.playerView stopPlay];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    //纠正首次显示位置错乱问题
    if (self.firstAppear) {
        [self.playerView relayout];
        self.editView.frame = CGRectMake(0,self.toolVIew.frame.origin.y - 108-24, self.view.frame.size.width, 108);
        self.editView.originalFrame = self.editView.frame;
        self.firstAppear = NO;
    }
}

-(void)addNotify
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self.progressView addTarget:self action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.progressView removeTarget:self action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)addTimer
{
//    __weak PlayerViewController * weakself = self;
//    _timer = [NSTimer timerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakself.showToolBar = NO;
//        });
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)addGesture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeHandler)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}

-(void)tap:(UIGestureRecognizer*)gesture
{
    [CommonTool resign];
//    self.showToolBar = !_showToolBar;
    
}

-(void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    [self resetControll];
}

-(void)resetControll
{
    self.deleteBtn.hidden = (self.enabled)?NO:YES;
    self.editView.enabled = self.enabled;
}

-(void)setShowToolBar:(BOOL)showToolBar
{
    _showToolBar = showToolBar;
    
//    self.toolVIew.hidden = !_showToolBar;
//    self.navBar.hidden = !_showToolBar;
    
    if (_showToolBar) {
        [self addTimer];
    }else {
        [_timer invalidate];
    }
}

-(void)setLandscapeRight
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.shouldLandscapeRight = TRUE;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

-(void)orientationWillChange:(NSNotification*)notify
{
    NSInteger orientation = [[notify.userInfo objectForKey:@"UIApplicationStatusBarOrientationUserInfoKey"] integerValue];
    if ((UIInterfaceOrientationLandscapeRight == orientation) || (UIInterfaceOrientationLandscapeLeft == orientation)) {
        self.isFull = YES;
    }else {
        self.isFull = NO;
    }
}

//解决屏幕旋转视频界画面不适配的情形
-(void)orientationDidChanged:(NSNotification*)notify
{
    [self.playerView relayout];
}

-(void)setIsFull:(BOOL)isFull
{
    _isFull = isFull;
    if (!_isFull) {
        [self.fullscreenBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    }else {
        [self.fullscreenBtn setImage:[UIImage imageNamed:@"halfscreen"] forState:UIControlStateNormal];
    }
    self.editView.hidden = _isFull;
}

-(void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    if (_isPlaying) {
        [self.playpauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else {
        [self.playpauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

-(void)showOn:(UIViewController*)viewCtrl
{
    self.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [viewCtrl presentViewController:self animated:YES completion:^{
        
    }];
}


- (IBAction)back:(id)sender {
  
    [self dismiss];
}

-(void)dismiss
{
    __weak  typeof(self) weakSelf = self;
    [self dismissWithCompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.dissmissBlock) {
            strongSelf.dissmissBlock(strongSelf.tagString,strongSelf.commentString, strongSelf.hasModify);
        }
    }];
}

-(void)dismissWithCompletion:(void (^ __nullable)(void))completion
{
    
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(self) strongSelf = weakself;
        strongSelf.view.frame = CGRectMake(0, self.view.frame.size.height, strongSelf.view.frame.size.width, strongSelf.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakself;
        [strongSelf dismissViewControllerAnimated:NO completion:completion];
    }];

}


- (IBAction)playPauseBtnClicked:(id)sender {
    if (self.isPlaying) {
        [self.playerView pause];
    }else {
        [self.playerView play];
    }
}

- (IBAction)volumeBtnClicked:(id)sender {
    self.isMute = !_isMute;
}

- (IBAction)deleteBtnClicked:(id)sender {
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    [self dismiss];
}

- (IBAction)confirmBtnClicked:(id)sender {
    [self dismiss];
}


-(void)setIsMute:(BOOL)isMute
{
    _isMute = isMute;
    if (_isMute) {
        [self.playerView setVolume:0];
        [self.volumeBtn setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    }else {
        [self.playerView setVolume:1];
        [self.volumeBtn setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
    }
}

- (IBAction)fullScreenBtnClicked:(id)sender {
//    if (self.playerView.aspectRatio < 1) {
//        return;
//    }
    if (!self.isFull) {
        [self changeOrientation:UIInterfaceOrientationLandscapeRight];
    }else {
        [self changeOrientation:UIInterfaceOrientationPortrait];
    }
}


-(void)playerView:(AVPlayerView*)view playerStatusChanged:(AVPlayerStatus)status
{
    switch (status) {
        case AVPlayerStatusReadyToPlay:
        {
            __weak PlayerViewController * weakself = self;
            self.totalTimeLab.text = [self getTimeString:[self.playerView getDuration]];
            [self.playerView addTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                weakself.progressView.value = CMTimeGetSeconds(time)/CMTimeGetSeconds([weakself.playerView getDuration]);
                weakself.currentTimeLab.text = [weakself getTimeString:time];
            }];
            
        }
            break;
            
        default:
            break;
            
    }
}


-(void)playerView:(AVPlayerView*)view controlStatusChanged:(AVPlayerTimeControlStatus)status
{
    switch (status) {
        case AVPlayerTimeControlStatusPaused:
        {
            self.isPlaying = NO;
        }
            break;
        case AVPlayerTimeControlStatusPlaying:
        {
            self.isPlaying = YES;
        }
            break;
            
        default:
            break;
    }
}


-(void)progressChanged:(id)sender
{
    if ([sender isKindOfClass:[LineProgressView class]]) {
        LineProgressView * progressView = sender;
        [self.playerView setProgress:progressView.value];
    }
}

//00:00
-(NSString*)getTimeString:(CMTime)time
{
    NSInteger totalseconds = ceilf(CMTimeGetSeconds(time));
    NSInteger minute = totalseconds/60;
    NSInteger second = totalseconds%60;
    NSString * text = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    return text;
    
}

//// 横屏 home键在右边
//-(void)forceOrientationLandscapeWith:(UIViewController *)VC{
//
//////    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//////    appdelegate.isForcePortrait=NO;
//////    appdelegate.isForceLandscape=YES;
//////    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:VC.view.window];
//    //强制翻转屏幕，Home键在右边。
//    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
//    //刷新
//    [UIViewController attemptRotationToDeviceOrientation];
//}

- (void)changeOrientation:(UIInterfaceOrientation)orientation
{
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(void)setTagString:(NSString *)tagString
{
    _tagString = tagString;

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.editView.tagString = tagString;
        [strongSelf resetControll];
    });
}

-(void)setCommentString:(NSString *)commentString
{
    _commentString = commentString;

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.editView.commentString = commentString;
    });
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    //必须保留，啥也不干
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    //必须保留，啥也不干
}

@end
