//
//  CommonDefine.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/10.
//

#ifndef CommonDefine_h
#define CommonDefine_h

typedef NS_ENUM(NSInteger, RecognizeType) {
    RecognizeTypePlateNO                = 0,
    RecognizeTypeDrivingLicence         = 1,
    RecognizeTypeVIN                    = 2,
    RecognizeTypeQRCode                 = 3
};


#define CornerRadius 4.0

#define URL_AGREEMENT @"https://web.enoch-car.com/h5/agreement/userAgreement.html"
#define URL_PRIVACY @"https://web.enoch-car.com/h5/agreement/privacyPolicy.html"
#define URL_HELP @"https://help.qxeasy.com/"


//Notification name
#define NOTIFICATION_LOGIN_SUCCESS @"loginSuccessNotification"
#define NOTIFICATION_LOGIN_FAILURE @"loginFailureNotification"
#define NOTIFICATION_LOGIN_SKIP    @"loginSkipNotification"
#define NOTIFICATION_LOGOUT_SUCCESS @"logoutSuccessNotification"
#define NOTIFICATION_SHOWLOGIN    @"showLoginNotification"
#define NOTIFICATION_Agreement    @"Agreement"      //同意协议和隐私权政策



//userdefaults
#define USERDEFAULTS_ACCOUNT @"userAccount"
#define USERDEFAULTS_PASSWORD @"userPassword"
#define USERDEFAULTS_SSOUserID @"SSOUserID"
#define USERDEFAULTS_UMengInit @"isUMengInit"/*同意隐私和协议后才能初始化友盟（该标记可同时标记同意隐私协议和初始化友盟）*/
#define USERDEFAULTS_FIRSTAGREE @"firstAgree"
#define USERDEFAULTS_FIRSTLOGIN @"firstLogin"



//text
#define TEXT_NETWORKOFF @"(无网络)"
#define TEXT_NETWORKOFF_HINT @"当前网络异常"




#endif /* CommonDefine_h */
