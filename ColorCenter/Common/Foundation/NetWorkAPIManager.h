//
//  NetWorkAPIManager.h
//  EnochCar
//
//  Created by 王海燕 on 2021/5/10.
//

#import <Foundation/Foundation.h>    
#import "AFNetworking.h"
#import "CommonDefine.h"
#import "User.h"
//#import "SpraySerivice.h"
//#import "ChargingMethod.h"
//#import "WorkingTeam.h"
//#import "Vehicle.h"
//#import "Message.h"
#import "Hint.h"
#import "ResponseObject.h"
#import "SignatureModel.h"
//#import "User+Tool.h"


//#define BASEURL  @"https://color.enoch-car.com"
#define BASEURL  @"https://colord.enoch-car.com"
#define APPLICATIONURL @"https://h5.enoch-car.com/api/open/application"
NS_ASSUME_NONNULL_BEGIN


@interface NetWorkAPIManager : NSObject
@property(nonatomic,readwrite,strong)AFHTTPSessionManager * manager;

@property(nullable,nonatomic,strong) User * curUser;
@property(nonatomic,readwrite,strong) SignatureModel * ocrSignature;
@property(nonatomic,readwrite,strong) SignatureModel * ossSignature;

@property(nullable,nonatomic, copy) NSArray *vehicleModels;//车品牌列表


+(instancetype)defaultManager;

-(void)resetManager;

// 统一的get接口，处理二次确认
- (nullable NSURLSessionDataTask *)GETManager:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

// 统一的post接口，处理二次确认
- (nullable NSURLSessionDataTask *)POSTManager:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

// 统一的put接口，处理二次确认
- (NSURLSessionDataTask *)PUTManager:(NSString *)URLString
                   parameters:(nullable id)parameters
                      headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                      success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;


//tool
-(NSString *)getURLWithAppendStr:(NSString*)appendStr;
-(NSString*)DataTOjsonString:(id)object;



-(void)commonGET:(NSString *)url parm:(NSDictionary *)parm registerClass:(Class)registerClass Success:(nullable void (^)(NSURLSessionDataTask *task, ResponseObject * responseObj))success
         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

-(void)commonPUT:(NSString *)url parm:(NSDictionary *)parm Success:(nullable void (^)(NSURLSessionDataTask *task, ResponseObject * responseObj))success
         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

-(void)commonPOST:(NSString *)url parm:(NSDictionary *)parm registerClass:(Class)registerClass Success:(nullable void (^)(NSURLSessionDataTask *task, ResponseObject * responseObj))success
          Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

-(void)commonDelete:(NSString *)url parm:(NSDictionary *)parm Success:(nullable void (^)(NSURLSessionDataTask *task, ResponseObject * responseObj))success
            Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//非客户申请开通账户
-(void)application:(NSDictionary *)info Success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
           Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//登录
-(void)loginWithUsername:(NSString *)name Password:(NSString *)password success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//退出登录
-(void)logoutsuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
             failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//查询当前用户信息
-(void)getUserInfosuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//获取系统配置
-(void)getBranchAttributeSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
//获取表单设置
-(void)getgetFormSettingSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
//获取oss签名
-(void)getOSSSignatureSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//修改密码
-(void)modifyPassword:(NSString*)oldPassword newPwd:(NSString *)newPassword confirmPwd:(NSString *)confirmPwd success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


//获取车辆品牌(奥迪、宝马等)
-(void)queryVehicleBrandsuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


//获取地区
-(void)queryAreaWithCode:(nullable NSNumber*)code Success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                            Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


//上传图片
-(NSURLSessionDataTask *)uploadData:(NSData *)data signature:(NSDictionary*)signature success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//上传视频
-(NSURLSessionDataTask *)uploadVideo:(NSData *)data signature:(NSDictionary*)parm success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
           failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

////车牌、行驶证、VIN识别
//-(NSURLSessionDataTask *)recognizeWithImageUrl:(NSString *)imageUrlStr Type:(RecognizeType)type success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
//                                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//VIN码解析
-(void)vinParse:(NSString *)vin Success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                            Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


////发送短信
//-(void)sendMsgWith:(NSNumber *)serviceId cellphones:(NSArray *)cellphones
//           Success:(nullable void (^)(NSURLSessionDataTask *task, NSArray<Message*> *data))success
//           failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;



-(void)lookup:(NSString *)type success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

-(void)hint:(NSString *)type success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

-(void)putHint:(NSString *)code data:(NSArray *)dataArray success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


//用户反馈
-(void)feedbackWithContent:(NSString*)contentStr success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;



//获取app 在appstore上的最新版本
-(void)getAppNewestVersionSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                            Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//获取版本升级配置
-(void)getVersionConfigSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                       Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//取消当前请求
- (void)cancelRequest;
//取消所有任务
-(void)cancelAllTask;

@end

NS_ASSUME_NONNULL_END
