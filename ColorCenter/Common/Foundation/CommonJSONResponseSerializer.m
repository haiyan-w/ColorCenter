//
//  CommonJSONResponseSerializer.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/25.
//

#import "CommonJSONResponseSerializer.h"

@implementation CommonJSONResponseSerializer


-(id)responseObjectForResponse:(NSURLResponse *)response
                          data:(NSData *)data
                         error:(NSError *__autoreleasing *)error
{
//    NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"JSONString====%@",str);
   id JSONObject = [super responseObjectForResponse:response data:data error:error]; // may mutate `error`

       if (*error != nil) {
           NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
           [userInfo setValue:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:JSONResponseSerializerWithDataKey];
           [userInfo setValue:[response valueForKey:JSONResponseSerializerWithBodyKey] forKey:JSONResponseSerializerWithBodyKey];
           NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
           (*error) = newError;
       }

   return JSONObject;
}


@end
