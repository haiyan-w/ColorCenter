//
//  ResponseObject.m
//  EnochCar
//
//  Created by 王海燕 on 2022/6/23.
//

#import "ResponseObject.h"


@implementation ConfirmedOption

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (dictionary) {
            self.code = [dictionary objectForKey:@"code"];
            self.message = [dictionary objectForKey:@"message"];
            self.primary = [dictionary objectForKey:@"primary"];
        }
    }
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
    [dictionary setValue:self.code forKey:@"code"];
    [dictionary setValue:self.message forKey:@"message"];
    [dictionary setValue:self.primary forKey:@"primary"];
    return dictionary;
}

@end





@implementation Confirmation

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (dictionary) {
            self.code = [dictionary objectForKey:@"code"];
            self.confirmedOption = [[ConfirmedOption alloc] initWithDictionary:[dictionary objectForKey:@"confirmedOption"]];
            self.doubleCheck = [dictionary objectForKey:@"doubleCheck"];
            self.message = [dictionary objectForKey:@"message"];
            self.options = [dictionary objectForKey:@"options"];
            self.parameters = [dictionary objectForKey:@"parameters"];
        }
    }
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
    [dictionary setValue:self.code forKey:@"code"];
    [dictionary setValue:[self.confirmedOption convertToDictionary] forKey:@"confirmedOption"];
    [dictionary setValue:self.doubleCheck forKey:@"doubleCheck"];
    [dictionary setValue:self.message forKey:@"message"];
    [dictionary setValue:self.options forKey:@"options"];
    [dictionary setValue:self.parameters forKey:@"parameters"];
    return dictionary;
}

@end



@implementation Paging

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (dictionary) {
            self.itemCount = [dictionary objectForKey:@"itemCount"];
            self.pageCount = [dictionary objectForKey:@"pageCount"];
            self.pageIndex = [dictionary objectForKey:@"pageIndex"];
            self.pageSize = [dictionary objectForKey:@"pageSize"];
        }
    }
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
    [dictionary setValue:self.itemCount forKey:@"itemCount"];
    [dictionary setValue:self.pageCount forKey:@"pageCount"];
    [dictionary setValue:self.pageIndex forKey:@"pageIndex"];
    [dictionary setValue:self.pageSize forKey:@"pageSize"];
    return dictionary;
}

@end



@implementation Meta

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (dictionary) {
            self.paging = [[Paging alloc] initWithDictionary:[dictionary objectForKey:@"paging"]];
            self.sessionKeys = [dictionary objectForKey:@"sessionKeys"];
        }
    }
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
    [dictionary setValue:[self.paging convertToDictionary] forKey:@"paging"];
    [dictionary setValue:self.sessionKeys forKey:@"sessionKeys"];
    return dictionary;
}

@end



@implementation Error

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (dictionary) {
            self.code = [dictionary objectForKey:@"code"];
            self.message = [dictionary objectForKey:@"message"];
            self.parameters = [dictionary objectForKey:@"parameters"];
            self.reason = [dictionary objectForKey:@"reason"];
        }
    }
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
    [dictionary setValue:self.code forKey:@"code"];
    [dictionary setValue:self.message forKey:@"message"];
    [dictionary setValue:self.parameters forKey:@"parameters"];
    [dictionary setValue:self.reason forKey:@"reason"];
    return dictionary;
}

@end



@implementation Warning

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (dictionary) {
            self.code = [dictionary objectForKey:@"code"];
            self.message = [dictionary objectForKey:@"message"];
            self.parameters = [dictionary objectForKey:@"parameters"];
        }
    }
    return self;
}

-(NSDictionary*)convertToDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
    [dictionary setValue:self.code forKey:@"code"];
    [dictionary setValue:self.message forKey:@"message"];
    [dictionary setValue:self.parameters forKey:@"parameters"];
    return dictionary;
}

@end



@implementation ResponseObject

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
//{
//    self = [super initWithDictionary:dictionary];
//    if (self) {
//        if (dictionary) {
//            NSMutableArray * confirmations = [dictionary objectForKey:@"confirmations"];
//            NSMutableArray * confirmationObjs = [NSMutableArray array];
//            for (NSDictionary * dic in confirmations) {
//                Confirmation * obj = [[Confirmation alloc] initWithDictionary:dic];
//                [confirmationObjs addObject:obj];
//            }
//            self.confirmations = confirmationObjs;
//
//            self.data = [dictionary objectForKey:@"data"];
//
//            self.meta = [[Meta alloc] initWithDictionary:[dictionary objectForKey:@"meta"]];
//            self.extraData = [dictionary objectForKey:@"extraData"];
//
//            NSMutableArray * errors = [dictionary objectForKey:@"errors"];
//            NSMutableArray * errorsObjs = [NSMutableArray array];
//            for (NSDictionary * dic in errors) {
//                Error * obj = [[Error alloc] initWithDictionary:dic];
//                [errorsObjs addObject:obj];
//            }
//            self.errors = errorsObjs;
//
//            NSMutableArray * warnings = [dictionary objectForKey:@"warnings"];
//            NSMutableArray * warningsObjs = [NSMutableArray array];
//            for (NSDictionary * dic in warnings) {
//                Error * obj = [[Error alloc] initWithDictionary:dic];
//                [warningsObjs addObject:obj];
//            }
//            self.warnings = warningsObjs;
//
//        }
//    }
//    return self;
//}


//暂时用不到convertToDictionary
//-(NSDictionary*)convertToDictionary
//{
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
//
//    return dictionary;
//}


+ (NSDictionary *)arrayContainModelClass {
    return @{@"confirmations" : @"Confirmation", @"errors" : @"Error", @"warnings" : @"Warning"};
}

@end
