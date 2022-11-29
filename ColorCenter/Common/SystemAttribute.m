//
//  SystemAttribute.m
//  EnochCar
//
//  Created by 王海燕 on 2021/12/30.
//

#import "SystemAttribute.h"

@implementation SystemAttribute
-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (dictionary) {
            self.id = [[Attribute alloc] initWithDictionary:[dictionary objectForKey:@"id"]];
            self.value = [dictionary objectForKey:@"value"];
        }
        
    }
    
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:[self.id convertToDictionary]forKey:@"id"];
    [dictionary setValue:self.value forKey:@"value"];

    return dictionary;
}

@end








@implementation Attribute

@synthesize description = _description;

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (dictionary) {
            self.valueType = [dictionary objectForKey:@"valueType"];
            self.code = [dictionary objectForKey:@"code"];
            self.keyType = [[CommonType alloc] initWithDictionary:[dictionary objectForKey:@"keyType"]];
            self.message = [dictionary objectForKey:@"message"];
            self.type = [dictionary objectForKey:@"type"];
            self.description = [dictionary objectForKey:@"description"];
            self.onAttributeKey = [dictionary objectForKey:@"onAttributeKey"];
            self.onAttributeValues = [dictionary objectForKey:@"onAttributeValues"];
        }
    }
    
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.valueType forKey:@"valueType"];
    [dictionary setValue:self.code forKey:@"code"];
    [dictionary setValue:[self.keyType convertToDictionary]forKey:@"keyType"];
    [dictionary setValue:self.message forKey:@"message"];
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.description forKey:@"description"];
    [dictionary setValue:self.onAttributeKey forKey:@"onAttributeKey"];
    [dictionary setValue:self.onAttributeValues forKey:@"onAttributeValues"];

    return dictionary;
}

@end
