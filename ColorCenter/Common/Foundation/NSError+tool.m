//
//  NSError+tool.m
//  EnochCar
//
//  Created by 王海燕 on 2021/12/30.
//

#import "NSError+tool.h"
#import "CommonTool.h"


@implementation NSError (tool)

-(NSString *)errorMessage
{
    NSString * message = @"";
    switch (self.code) {
        case -1001:
        {
            message = @"网络不给力，请稍后再试";
        }
            break;
        case -1009:
        {
            message = @"当前无网络连接";
        }
            break;
        case -1011:
        {
            //NSURLErrorBadServerResponse
            NSString * info = [self.userInfo objectForKey:@"body"];
            NSDictionary * dic = [CommonTool dictionaryWithJsonString:info];
            NSNumber * statusCode = [dic objectForKey:@"status"];
            if (statusCode.integerValue == 503) {
                message = @"系统正在升级...";
            }else if (statusCode.integerValue == 403) {
                //Token无效，重新登录
                message = @"登录超时，请重新登录";
            }else {
                NSDictionary * msgDic = [[dic objectForKey:@"errors"] firstObject];
                message = [msgDic objectForKey:@"message"];
            }
        }
            break;
        case 400:
        {
            NSString * info = [self.userInfo objectForKey:@"body"];
            NSDictionary * dic = [CommonTool dictionaryWithJsonString:info];
            NSDictionary * msgDic = [[dic objectForKey:@"errors"] firstObject];
            message = [msgDic objectForKey:@"message"];
        }
            break;
        case 403:
        {
            //Token无效，重新登录
            message = @"登录超时，请重新登录";
        }
            break;
        case 503:
        {
            message = @"系统正在升级...";
        }
            break;
            
        default:
        {
            NSString * info = [self.userInfo objectForKey:@"body"];
            NSDictionary * dic = [CommonTool dictionaryWithJsonString:info];
            NSDictionary * msgDic = [[dic objectForKey:@"errors"] firstObject];
            message = [msgDic objectForKey:@"message"];
        }
            break;
    }
            
    if ((!message)||(message.length == 0)) {
            message = @"服务器异常";
    }
        
    return message;
}

@end
