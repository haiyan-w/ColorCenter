//
//  FirstAgreementViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2022/1/10.
//

#import "FirstAgreementViewController.h"
#import "CommonDefine.h"
#import "AgreementViewController.h"
#import "CommonButton.h"
#import "UIFont+CustomFont.h"
#import "UIColor+CustomColor.h"

typedef enum
{
    FirstTip,
    SecondTip
}AgreementMode;

@interface FirstAgreementViewController ()<UITextViewDelegate>
@property(nonatomic,assign) AgreementMode mode;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *notAgreeBtn;
@property (strong, nonatomic) IBOutlet CommonButton *continueBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerTextHeightConstraint;

@end

@implementation FirstAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLab.numberOfLines  = 0;
    
    self.continueBtn.titleLabel.font = [UIFont smallButtonTitleFont];
    self.notAgreeBtn.layer.borderColor = [UIColor borderColor].CGColor;
    
//    self.textView.selectable = NO;//设置NO，url链接点击无响应
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.textView.editable = NO;
    self.textView.delegate = self;
    self.textView.tintColor = [UIColor tintColor];
    self.mode = FirstTip;
}

-(void)setMode:(AgreementMode)mode
{
    _mode = mode;
    NSString * title = @"";
    NSString * text = @"";
    switch (mode) {
        case FirstTip:
        {
            title = [NSString stringWithFormat:@"感谢您使用\r\n以诺行颜色中心APP"];
            [self.notAgreeBtn setTitle:@"不同意" forState:UIControlStateNormal];
            text = @"我们非常重视对您的个人信息保护，请您在使用之前务必查看以诺行用户协议和隐私权政策，点击“同意并继续”代表您同意前述的以诺行用户协议和隐私权政策并开启以诺行颜色中心的使用。";
            
        }
            break;
        case SecondTip:
        {
            title = @"欢迎使用以诺行颜色中心";
            [self.notAgreeBtn setTitle:@"退出应用" forState:UIControlStateNormal];
            text = @"根据政策要求，您需要同意以诺行用户协议和隐私权政策，点击“同意并继续”代表您同意前述的以诺行用户协议和隐私权政策并开启以诺行颜色中心的使用。";
        }
            break;
            
        default:
            break;
    }
    
    NSMutableAttributedString * titleAttr = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    NSRange titleRange = [title rangeOfString:title];
    [titleAttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]} range:titleRange];
    [titleAttr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:titleRange];
    self.titleLab.attributedText = titleAttr;
    [self.titleLab sizeToFit];
    
    NSMutableAttributedString * attrText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    NSRange range = [text rangeOfString:text];
    NSRange range1 = [text rangeOfString:@"以诺行用户协议"];
    NSRange range2 = [text rangeOfString:@"隐私权政策"];
    NSURL * url1= [NSURL URLWithString:URL_AGREEMENT];
    NSURL * url2= [NSURL URLWithString:URL_PRIVACY];

    [attrText addAttributes:@{NSLinkAttributeName:url1} range:range1];
    [attrText addAttributes:@{NSLinkAttributeName:url2} range:range2];
    [attrText addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle1} range:range];
    [attrText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]} range:range];
    [attrText addAttributes:@{NSForegroundColorAttributeName:[UIColor textColor]} range:range];
    self.textView.attributedText = attrText;
    [self.textView sizeToFit];
    CGRect rect =  [attrText boundingRectWithSize:CGSizeMake(self.textView.frame.size.width, 200) options:NSStringDrawingUsesLineFragmentOrigin context:NULL];
    self.centerTextHeightConstraint.constant = rect.size.height+28;
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
}

- (IBAction)notAgreementBtnClicked:(id)sender {
    switch (self.mode) {
        case FirstTip:
        {
            self.mode = SecondTip;
        }
            break;
        case SecondTip:
        {
            exit(0);
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)continueBtnClicked:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERDEFAULTS_FIRSTAGREE];
    
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


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    if ([URL.absoluteString isEqualToString:URL_AGREEMENT]) {
        AgreementViewController * agreementCtrl = [[AgreementViewController alloc] initWithResource:URL_AGREEMENT];
        [agreementCtrl showIn:self];
    }else {
        AgreementViewController * agreementCtrl = [[AgreementViewController alloc] initWithResource:URL_PRIVACY];
        [agreementCtrl showIn:self];
    }
    
    return NO;
}

@end
