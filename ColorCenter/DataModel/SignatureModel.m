//
//  SignatureModel.m
//  EnochCar
//
//  Created by 王海燕 on 2022/7/28.
//

#import "SignatureModel.h"

@implementation SignatureModel

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
//{
//    self = [super initWithDictionary:dictionary];
//    if (self) {
//        if (dictionary) {
//            self.expire = [dictionary objectForKey:@"expire"];
//            self.OSSAccessKeyId = [dictionary objectForKey:@"OSSAccessKeyId"];
//            self.dir = [dictionary objectForKey:@"dir"];
//            self.policy = [dictionary objectForKey:@"policy"];
//            self.host = [dictionary objectForKey:@"host"];
//            self.accessId = [dictionary objectForKey:@"accessId"];
//            self.signature = [dictionary objectForKey:@"signature"];
//
//        }
//    }
//    return self;
//}
//
//-(NSDictionary*)convertToDictionary
//{
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
//    
//    [dictionary setValue:self.expire forKey:@"expire"];
//    [dictionary setValue:self.OSSAccessKeyId forKey:@"OSSAccessKeyId"];
//    [dictionary setValue:self.dir forKey:@"dir"];
//    [dictionary setValue:self.policy forKey:@"policy"];
//    [dictionary setValue:self.host forKey:@"host"];
//    [dictionary setValue:self.accessId forKey:@"accessId"];
//    [dictionary setValue:self.signature forKey:@"signature"];
//    return dictionary;
//}


//签名是否过期
-(BOOL)isExpired
{
    NSDate *expiredDate = [[NSDate alloc] initWithTimeIntervalSince1970:[self.expire longValue]];
    NSDate * nowDate = [NSDate date];
    if (NSOrderedDescending == [nowDate compare:expiredDate]) {
        return YES;
    }
    return NO;
}

@end
