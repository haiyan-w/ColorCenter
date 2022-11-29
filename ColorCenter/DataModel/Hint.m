//
//  Hint.m
//  EnochCar
//
//  Created by 王海燕 on 2022/3/23.
//

#import "Hint.h"


NSString * const HintTypePaymentMethod = @"PAMTMTD";




@implementation Hint

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
//{
//    self = [super initWithDictionary:dictionary];
//    if (self) {
//        if (dictionary) {
//            self.type = [[ValueType alloc] initWithDictionary:[dictionary objectForKey:@"type"]];
//            self.name = [dictionary objectForKey:@"name"];
//            self.hint = [dictionary objectForKey:@"hint"];
//        }
//    }
//    return self;
//}
//
//-(NSDictionary*)convertToDictionary
//{
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:[super convertToDictionary]];
//    
//    [dictionary setValue:[self.type convertToDictionary] forKey:@"type"];
//    [dictionary setValue:self.name forKey:@"name"];
//    [dictionary setValue:self.hint forKey:@"hint"];
//    return dictionary;
//}


@end
