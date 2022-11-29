//
//  CommonType.m
//  EnochCar
//
//  Created by 王海燕 on 2021/12/1.
//

#import "CommonType.h"

@implementation CommonType

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
//{
//    self = [super initWithDictionary:dictionary];
//    if (self) {
//        self.code = [dictionary objectForKey:@"code"];
//        self.descriptionStr = [dictionary objectForKey:@"description"];
//        self.message = [dictionary objectForKey:@"message"];
//        self.type = [dictionary objectForKey:@"type"];
//    }
//    return self;
//}
//
//-(NSDictionary*)convertToDictionary
//{
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
//
//    [dictionary setValue:self.code forKey:@"code"];
//    [dictionary setValue:self.descriptionStr forKey:@"description"];
//    [dictionary setValue:self.message forKey:@"message"];
//    [dictionary setValue:self.type forKey:@"type"];
//    return dictionary;
//}


@end

@implementation FlagType

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
//{
//    self = [super initWithDictionary:dictionary];
//    if (self) {
//        self.value = [dictionary objectForKey:@"value"];
//    }
//    return self;
//}
//
//-(NSDictionary*)convertToDictionary
//{
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
//    [dictionary setValue:self.value forKey:@"value"];
//    return dictionary;
//}


@end

@implementation ValueType

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
//{
//    self = [super initWithDictionary:dictionary];
//    if (self) {
//        self.valueType = [dictionary objectForKey:@"valueType"];
//    }
//    return self;
//}
//
//-(NSDictionary*)convertToDictionary
//{
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
//    [dictionary setValue:self.valueType forKey:@"valueType"];
//    return dictionary;
//}


@end



@implementation InflatedFlag

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
//{
//    self = [super initWithDictionary:dictionary];
//    if (self) {
//        self.inflated = [dictionary objectForKey:@"inflated"];
//    }
//    return self;
//}
//
//-(NSDictionary*)convertToDictionary
//{
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
//    [dictionary setValue:self.inflated forKey:@"inflated"];
//    return dictionary;
//}


@end








@implementation Clerk

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.id = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
    
    [dictionary setValue:self.id forKey:@"id"];
    [dictionary setValue:self.name forKey:@"name"];
    return dictionary;
}

@end








@implementation CustomerCategory

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.id = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
    }
    
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
    
    [dictionary setValue:self.id forKey:@"id"];
    [dictionary setValue:self.name forKey:@"name"];
    
    return dictionary;
}

@end
