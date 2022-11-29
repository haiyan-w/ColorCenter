//
//  NetWorkAPIManager.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/10.
//

#import "NetWorkAPIManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CommonJSONResponseSerializer.h"
#import "CommonTool.h"
#import "AlertViewController.h"
#import "NSDate+Tool.h"
#import "BaseModel.h"

//用户详情字段
#define USER_NAME @"name"
#define USER_ID   @"id"
#define USER_CELLPHONE @"cellphone"
#define USER_SSOUSER_ID @"ssoUserId"
#define USER_ACCESSRIGHTS @"accessRights"
#define USER_NAMEHINT @"nameHint"
#define USER_BRANCH @"branch"
#define BRANCH_NAME @"name"
#define BRANCH_ID @"id"


#define BWFileBoundary @"----WebKitFormBoundaryrXactNAchUCaIzMy"

#define BWNewLine @"\r\n"
#define BWEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@interface NetWorkAPIManager()
@property(nonatomic,readwrite,weak) NetWorkAPIManager * weakself;
@property(nonatomic,readwrite,strong) NSMutableDictionary * cookie;

@end


@implementation NetWorkAPIManager


static NetWorkAPIManager * apiManager;


+(instancetype)defaultManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        apiManager = [[NetWorkAPIManager alloc] init];
    });
    
    return apiManager;
}

-(instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _manager = [AFHTTPSessionManager manager];
    _weakself = self;
//    _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _manager.responseSerializer = [CommonJSONResponseSerializer serializer];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_manager.requestSerializer setValue:[CommonTool terminalString] forHTTPHeaderField:@"ENOCH_TERMINAL"];
    return self;
}

-(void)clearData
{
    self.curUser = nil;
    self.vehicleModels = nil;
}

-(void)resetManager
{
//    _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _manager.responseSerializer = [CommonJSONResponseSerializer serializer];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_manager.requestSerializer setValue:[self DataTOjsonString:self.cookie] forHTTPHeaderField:@"Cookie"];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_manager.requestSerializer setValue:[CommonTool terminalString] forHTTPHeaderField:@"ENOCH_TERMINAL"];
}

// 统一的get接口，处理二次确认
- (nullable NSURLSessionDataTask *)GETManager:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask * dataTask = [_manager GET:URLString
                                          parameters:parameters
                                             headers:headers
                                            progress:uploadProgress
                                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = responseObject;
        NSDictionary * warningDic = [[dic objectForKey:@"warnings"] firstObject];
        
        __strong typeof(self) strongSelf = weakSelf;
        if (warningDic) {
            [strongSelf showAlertWithTitle:@"" message:[warningDic objectForKey:@"message"]];

        }
        success(task,responseObject);
        
    }
                                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString * body = [error.userInfo objectForKey:@"body"];
        NSDictionary * dic = [CommonTool dictionaryWithJsonString:body];
        NSDictionary * confirmDic = [[dic objectForKey:@"confirmations"] firstObject];
        if (confirmDic) {
            __strong typeof(self) strongSelf = weakSelf;
            __weak typeof(self) weakSelf2 = strongSelf;
            [strongSelf showAlertWithTitle:@"" message:[confirmDic objectForKey:@"message"] yesAction:^{
                __strong typeof(self) strongSelf2 = weakSelf2;
                NSMutableDictionary * confirmation = [NSMutableDictionary dictionaryWithDictionary:confirmDic];
                [confirmation setValue:[[confirmation objectForKey:@"options"] firstObject] forKey:@"confirmedOption"];
                NSMutableDictionary * parmDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
                [parmDic setValue:@[confirmation] forKey:@"confirmations"];
                [strongSelf2.manager GET:URLString parameters:parmDic headers:headers progress:uploadProgress success:success failure:failure];
                
            } noAction:^{
                failure(task,error);
            }];
        }else {
            failure(task,error);
        }
        
    }];
    
    return dataTask;
}

// 统一的post接口，处理二次确认
- (nullable NSURLSessionDataTask *)POSTManager:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask * dataTask = [_manager POST:URLString
                                          parameters:parameters
                                             headers:headers
                                            progress:uploadProgress
                                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = responseObject;
        NSDictionary * warningDic = [[dic objectForKey:@"warnings"] firstObject];
        
        __strong typeof(self) strongSelf = weakSelf;
        if (warningDic) {
            [strongSelf showAlertWithTitle:@"" message:[warningDic objectForKey:@"message"]];

        }
        success(task,responseObject);
        
    }
                                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        __strong typeof(self) strongSelf = weakSelf;
         __weak typeof(self) weakSelf2 = strongSelf;
        
        NSString * body = [error.userInfo objectForKey:@"body"];
        NSDictionary * dic = [CommonTool dictionaryWithJsonString:body];
        NSDictionary * confirmDic = [[dic objectForKey:@"confirmations"] firstObject];
        if (confirmDic) {
            [strongSelf showAlertWithTitle:@"" message:[confirmDic objectForKey:@"message"] yesAction:^{
                NSMutableDictionary * confirmation = [NSMutableDictionary dictionaryWithDictionary:confirmDic];
                [confirmation setValue:[[confirmation objectForKey:@"options"] firstObject] forKey:@"confirmedOption"];
                NSMutableDictionary * parmDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
                [parmDic setValue:@[confirmation] forKey:@"confirmations"];
                __strong typeof(self) strongSelf2 = weakSelf2;
                [strongSelf2.manager POST:URLString parameters:parmDic headers:headers progress:uploadProgress success:success failure:failure];
                
            } noAction:^{
                failure(task,error);
            }];
        }else {
            failure(task,error);
        }
        
    }];
    
    return dataTask;
}


// 统一的put接口，处理二次确认
- (NSURLSessionDataTask *)PUTManager:(NSString *)URLString
                   parameters:(nullable id)parameters
                      headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                      success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask * dataTask = [_manager PUT:URLString
                                         parameters:parameters
                                            headers:headers
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
//        __weak typeof(self) weakSelf2 = strongSelf;
 
        NSDictionary * dic = responseObject;
        NSDictionary * warningDic = [[dic objectForKey:@"warnings"] firstObject];
        
        
        if (warningDic) {
            NSString * code = [warningDic objectForKey:@"code"];
            if ([code isEqualToString:@"INVALID_SERVICE_NEED_TO_APPROVAL"]) {
//                //需要审核
//                DocumentApplication * auditInfo = [[DocumentApplication alloc] init];
//                NSArray * data = [parameters objectForKey:@"data"];
//                NSDictionary * serviceDic = [data firstObject];
//                Service * service = [[Service alloc] initWithDictionary:serviceDic];
//                auditInfo.service = service;
//                auditInfo.type = [[CommonType alloc] initWithDictionary:@{@"code":@"SERVICE_DISCOUNT_RATE"}];
//                AuditDetailViewController * auditCtrl = [[AuditDetailViewController alloc] initWithInfo:auditInfo isToAudit:NO];
//                auditCtrl.operateBlock = ^(BOOL successed) {
//                    if (successed) {
//                        success(task,responseObject);
//                    }
//
//                };
//                [auditCtrl showOn:[UIApplication sharedApplication].keyWindow.rootViewController];
                
            }else {
                [strongSelf showAlertWithTitle:@"" message:[warningDic objectForKey:@"message"]];
            }
            

        }
        success(task,responseObject);
        
    }
                                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
         __weak typeof(self) weakSelf2 = strongSelf;
        
        NSString * body = [error.userInfo objectForKey:@"body"];
        NSDictionary * dic = [CommonTool dictionaryWithJsonString:body];
        NSDictionary * confirmDic = [[dic objectForKey:@"confirmations"] firstObject];
        if (confirmDic) {
            [strongSelf showAlertWithTitle:@"" message:[confirmDic objectForKey:@"message"] yesAction:^{
                NSMutableDictionary * confirmation = [NSMutableDictionary dictionaryWithDictionary:confirmDic];
                [confirmation setValue:[[confirmation objectForKey:@"options"] firstObject] forKey:@"confirmedOption"];
                NSMutableDictionary * parmDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
                [parmDic setValue:@[confirmation] forKey:@"confirmations"];
                __strong typeof(self) strongSelf2 = weakSelf2;
                [strongSelf2.manager PUT:URLString parameters:parmDic headers:NULL success:success failure:failure];
                
            } noAction:^{
                failure(task,error);
            }];
        }else {
            failure(task,error);
        }
        
    }];
    
    return dataTask;
}


// 统一的Delete接口，处理二次确认
- (nullable NSURLSessionDataTask *)DeleteManager:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask * dataTask = [_manager DELETE:URLString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;

        NSDictionary * dic = responseObject;
        NSDictionary * warningDic = [[dic objectForKey:@"warnings"] firstObject];
        if (warningDic) {
            [strongSelf showAlertWithTitle:@"" message:[warningDic objectForKey:@"message"]];

        }
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
         __weak typeof(self) weakSelf2 = strongSelf;
        
        NSString * body = [error.userInfo objectForKey:@"body"];
        NSDictionary * dic = [CommonTool dictionaryWithJsonString:body];
        NSDictionary * confirmDic = [[dic objectForKey:@"confirmations"] firstObject];
        if (confirmDic) {
            [strongSelf showAlertWithTitle:@"" message:[confirmDic objectForKey:@"message"] yesAction:^{
                NSMutableDictionary * confirmation = [NSMutableDictionary dictionaryWithDictionary:confirmDic];
                [confirmation setValue:[[confirmation objectForKey:@"options"] firstObject] forKey:@"confirmedOption"];
                NSMutableDictionary * parmDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
                [parmDic setValue:@[confirmation] forKey:@"confirmations"];
                __strong typeof(self) strongSelf2 = weakSelf2;
                [strongSelf2.manager DELETE:URLString parameters:parmDic headers:headers success:success failure:failure];
                
            } noAction:^{
                failure(task,error);
            }];
        }else {
            failure(task,error);
        }
        
    }];
    
    return dataTask;
}




- (void)commonGET:(NSString *)url parm:(NSDictionary *)parm registerClass:(Class)registerClass Success:(nullable void (^)(NSURLSessionDataTask *task, ResponseObject * responseObj))success
         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:url];

    [self resetManager];
    
    [self GETManager:urlString parameters:parm headers:NULL progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        ResponseObject * responseObj = [[ResponseObject alloc] initWithDictionary:responseObject];
        NSMutableArray * classArray = [NSMutableArray array];

        if ([registerClass isSubclassOfClass:[BaseModel class]]) {
            for (NSDictionary * dic in responseObj.data) {
                id obj = [registerClass modelWithDict2:dic];
                [classArray addObject:obj];
            }
            responseObj.data = classArray;
        }
        
        success(task,responseObj);
        
    } failure:failure];
}


-(void)commonPUT:(NSString *)url parm:(NSDictionary *)parm Success:(nullable void (^)(NSURLSessionDataTask *task, ResponseObject * responseObj))success
         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:url];
    
    NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:@[parm] forKey:@"data"];

    [self resetManager];
    
    [self PUTManager:urlString parameters:parmDic headers:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        ResponseObject * responseObj = [[ResponseObject alloc] initWithDictionary:responseObject];
        success(task,responseObj);
        
    } failure:failure];
}


-(void)commonPOST:(NSString *)url parm:(NSDictionary *)parm registerClass:(Class)registerClass Success:(nullable void (^)(NSURLSessionDataTask *task, ResponseObject * responseObj))success
         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:url];
    
    NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:@[parm] forKey:@"data"];

    [self resetManager];
    
    [self POSTManager:urlString parameters:parmDic headers:NULL progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        ResponseObject * responseObj = [[ResponseObject alloc] initWithDictionary:responseObject];
        NSMutableArray * classArray = [NSMutableArray array];
        
        if ([registerClass isSubclassOfClass:[BaseModel class]]) {
            for (NSDictionary * dic in responseObj.data) {
                id obj = [registerClass modelWithDict2:dic];
                [classArray addObject:obj];
            }
            responseObj.data = classArray;
        }
        
        success(task,responseObj);
        
    } failure:failure];
}

-(void)commonDelete:(NSString *)url parm:(NSDictionary *)parm Success:(nullable void (^)(NSURLSessionDataTask *task, ResponseObject * responseObj))success
         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:url];
    
    NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:@[parm] forKey:@"data"];

    [self resetManager];
    
    [self DeleteManager:urlString parameters:parmDic headers:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        ResponseObject * responseObj = [[ResponseObject alloc] initWithDictionary:responseObject];
        success(task,responseObj);
        
    } failure:failure];
}



-(void)application:(NSDictionary *)info Success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
           Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@",APPLICATIONURL];
    NSMutableDictionary * parmdic = [[NSMutableDictionary alloc] init];
    NSMutableArray * dataarray = [NSMutableArray arrayWithObject:info];
    [parmdic setValue:dataarray forKey:@"data"];
    
    [_manager POST:urlString parameters:parmdic headers:NULL progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:success failure:failure];
    
}

-(void)loginWithUsername:(NSString *)name Password:(NSString *)password success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/client/security/authenticate"];
    
    NSMutableDictionary * parmdic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * datadic = [[NSMutableDictionary alloc] init];
    [datadic setValue:[NSNumber numberWithBool:true]forKey:@"keepSignedIn"];
    [datadic setValue:name forKey:@"username"];
    [datadic setValue:password forKey:@"password"];
    
    NSMutableArray * dataarray = [NSMutableArray arrayWithObject:datadic];
    [parmdic setValue:dataarray forKey:@"data"];

    _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _manager.responseSerializer = [CommonJSONResponseSerializer serializer];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_manager.requestSerializer setValue:[CommonTool terminalString] forHTTPHeaderField:@"ENOCH_TERMINAL"];
    [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];//清除上一次登录的cookie

    __weak typeof (self) weakself = self;
    [self POSTManager:urlString parameters:parmdic headers:NULL progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        __strong typeof(self) strongSelf = weakself;
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
        NSDictionary * headDic = [response allHeaderFields];

        NSArray * cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headDic forURL:[NSURL URLWithString:BASEURL]];

        NSMutableDictionary * cookieDic= [NSMutableDictionary dictionary];

        for(NSHTTPCookie *cookie in cookies)
        {
            [cookieDic setValue:cookie.value forKey:cookie.name];

        }
        strongSelf.cookie = cookieDic;
        [strongSelf.manager.requestSerializer setValue:[strongSelf DataTOjsonString:strongSelf.cookie] forHTTPHeaderField:@"Cookie"];

        success(task, responseObject);
        
    } failure:failure];
}



//查询当前用户信息
-(void)getUserInfosuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/client/security/user"];

    [self resetManager];
    __weak  NetWorkAPIManager * weakself = self;
    [_manager GET:urlString parameters:NULL headers:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSDictionary * resultDic = responseObject;
        NSArray * array = [resultDic objectForKey:@"data"];
        NSDictionary * dic = [array firstObject];
        
        weakself.curUser = [[User alloc] initWithDictionary:dic];
        
        [weakself getOSSSignatureSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

        success(task,responseObject);
        
    } failure:failure];
  
}



-(void)logoutsuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
             failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/client/security/logout"];
    
    [self resetManager];
    
    __weak  typeof(self) weakSelf = self;
    [self POSTManager:urlString parameters:NULL headers:NULL progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf clearData];
       success(task, responseObject);
    }  failure:failure];
}

-(void)modifyPassword:(NSString*)oldPassword newPwd:(NSString *)newPassword confirmPwd:(NSString *)confirmPwd success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/client/security/password"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionary];
    [data setValue:oldPassword forKey:@"originalPassword"];
    [data setValue:newPassword forKey:@"newPassword"];
    [data setValue:confirmPwd forKey:@"confirm"];
    NSArray * array = [NSArray arrayWithObject:data];
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    [parm setValue:array forKey:@"data"];
    
    [self resetManager];
    
    [self POSTManager:urlString parameters:parm headers:NULL progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:success failure:failure];
    
}

//获取系统配置
-(void)getBranchAttributeSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/common/branch/attribute"];
    
    [self resetManager];
    
    [_manager GET:urlString parameters:NULL headers:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
    }success:success failure:failure];
}

//获取表单设置
-(void)getgetFormSettingSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                         Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/form/fields/setting"];
    
    [self resetManager];
    
    [_manager GET:urlString parameters:NULL headers:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
    }success:success failure:failure];
}

//获取oss签名
-(void)getOSSSignatureSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/common/oss/signature"];
    
    [self resetManager];
    
    __weak NetWorkAPIManager * weakself = self;
    [self POSTManager:urlString parameters:NULL headers:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * resp = responseObject;
        NSDictionary * data = [[resp objectForKey:@"data"] firstObject];
        
        NSString * dir = [data objectForKey:@"dir"];
        NSNumber *  expire = [data objectForKey:@"expire"];
        NSString * accessId = [data objectForKey:@"accessId"];
        NSString * host = [data objectForKey:@"host"];
        NSString * signature = [data objectForKey:@"signature"];
        NSString * policy = [data objectForKey:@"policy"];
        
        SignatureModel * ossSignature = [[SignatureModel alloc] init];
        ossSignature.OSSAccessKeyId = accessId;
        ossSignature.dir = dir;
        ossSignature.expire = expire;
        ossSignature.policy = policy;
        ossSignature.host = host;
        ossSignature.accessId = accessId;
        ossSignature.signature = signature;
        
        weakself.ossSignature = ossSignature;
        success(task,responseObject);
    } failure:failure];
   
}


//获取车辆品牌(奥迪、宝马等)
-(void)queryVehicleBrandsuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/common/vehicle/brand"];
    
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    int dep = 2;
    [parm setValue:[NSString stringWithFormat:@"%d",dep] forKey:@"depth"];
    
    [self resetManager];
    
    __weak typeof(self) weakSelf = self;
    [_manager GET:urlString parameters:parm headers:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = responseObject;
        NSArray * array = [dic objectForKey:@"data"];
        weakSelf.vehicleModels = [NSArray arrayWithArray:array];
        
        success(task,responseObject);
        
    } failure:failure];
    
}


-(void)queryAreaWithCode:(nullable NSNumber* )code Success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                            Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/common/area/children"];
    
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    [parm setValue:code forKey:@"parentCode"];
    
    [self resetManager];
   
    [_manager GET:urlString parameters:parm headers:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:success failure:failure];
    
}


-(void)feedbackWithContent:(NSString*)contentStr success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [self getURLWithAppendStr:@"/enocolor/common/feedback/submit"];
 
    NSMutableDictionary * data = [NSMutableDictionary dictionary];
    [data setValue:@"" forKey:@"title"];
    [data setValue:contentStr?contentStr:@"" forKey:@"content"];
    [data setValue:[NSDate nowDateStr] forKey:@"feedbackDate"];
    if (self.curUser.id) {
        [data setValue:[NSDictionary dictionaryWithObject:self.curUser.id forKey:@"id"] forKey:@"feedbackBy"];
    }
    
    NSArray * array = [NSArray arrayWithObject:data];
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    [parm setValue:array forKey:@"data"];

    [self resetManager];
    
    [self POSTManager:urlString parameters:parm headers:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:success failure:failure];
    
}

//上传图片和视频获取url
-(NSURLSessionDataTask *)uploadData:(NSData *)data signature:(NSDictionary*)parm success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@",[parm objectForKey:@"host"]];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BWFileBoundary];
    [_manager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"multipart/form-data", @"application/json", @"text/json", nil];
    [_manager.requestSerializer setValue:[CommonTool terminalString] forHTTPHeaderField:@"ENOCH_TERMINAL"];

    return [_manager POST:urlString parameters:parm headers:NULL constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString * filepath = [parm objectForKey:@"key"];
        NSString * filename = [filepath lastPathComponent];
        NSString *fileExtension = [filepath pathExtension];
        NSString * mimeType = @"image/jpeg";
        if([fileExtension isEqualToString:@"jpg"]||[fileExtension isEqualToString:@"gif"]||[fileExtension isEqualToString:@"png"]||[fileExtension isEqualToString:@"jpeg"]||[fileExtension isEqualToString:@"bmp"])
        {
            mimeType = [NSString stringWithFormat:@"image/%@",fileExtension];
            
        }else if([fileExtension isEqualToString:@"mp4"]||[fileExtension isEqualToString:@"mov"]){
            
            mimeType = [NSString stringWithFormat:@"video/%@",fileExtension];
        }
        
        [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:success failure:failure];
}

//上传视频
-(NSURLSessionDataTask *)uploadVideo:(NSData *)data signature:(NSDictionary*)parm success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@",[parm objectForKey:@"host"]];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BWFileBoundary];
    [_manager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/xml", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [_manager.requestSerializer setValue:[CommonTool terminalString] forHTTPHeaderField:@"ENOCH_TERMINAL"];

    return [_manager POST:urlString parameters:parm headers:NULL constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString * filepath = [parm objectForKey:@"key"];
        NSString * filename = [filepath lastPathComponent];
        NSString *fileExtension = [filepath pathExtension];
        NSString * mimeType = @"video/mov";
        if([fileExtension isEqualToString:@"mp4"]||[fileExtension isEqualToString:@"mov"]){
            
            mimeType = [NSString stringWithFormat:@"video/%@",fileExtension];
        }
        
        [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:success failure:failure];
}


- (void)cancelRequest
{
    if ([_manager.tasks count] > 0) {
        [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}


-(void)cancelAllTask
{
    [_manager.operationQueue cancelAllOperations];    
}


-(void)getAppNewestVersionSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                 Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSString * urlString =@"https://itunes.apple.com/cn/lookup?id=1580542245";
    
    _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _manager.responseSerializer = [CommonJSONResponseSerializer serializer];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [_manager POST:urlString parameters:NULL headers:NULL progress:NULL success:success failure:failure];
    
}

//获取版本升级配置
-(void)getVersionConfigSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                       Failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
//    NSString * urlString = @"https://enocherp-oss01.oss-cn-hangzhou.aliyuncs.com/app/iOS/releaseConfig.json";
    NSString * urlString = @"https://resource.enoch-car.com/app/iOS/releaseConfig.json";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self resetManager];
    
    [_manager GET:urlString parameters:NULL headers:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:success failure:failure];
}



#pragma mark Tool
-(NSString *)getURLWithAppendStr:(NSString*)appendStr
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASEURL,appendStr];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlString;
}


-(NSString*)DataTOjsonString:(id)object
{
    if (!object) {
        return @"";
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
    options:NSJSONWritingPrettyPrinted
    error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    AlertAction * sure = [[AlertAction alloc] initWithTitle:@"知道了" action:^(id _Nonnull arg) {
        
    }];
    AlertViewController * alert = [[AlertViewController alloc] initWithTitle:title message:message position:AlertCenter actions:@[sure]];
    [alert showOn:[UIApplication sharedApplication].keyWindow.rootViewController];
}


//二次确认弹窗
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message yesAction:(void (^)(void))yesBlock noAction:(void (^)(void))noBlock
{
    AlertAction * cancel = [[AlertAction alloc] initWithTitle:@"取消" action:^(id _Nonnull arg) {
        noBlock();
    }];
    AlertAction * sure = [[AlertAction alloc] initWithTitle:@"确定" action:^(id _Nonnull arg) {
        yesBlock();
    }];
    
    AlertViewController * alert = [[AlertViewController alloc] initWithTitle:title message:message position:AlertCenter actions:@[cancel,sure]];
    [alert showOn:[UIApplication sharedApplication].keyWindow.rootViewController];
    
}


@end
