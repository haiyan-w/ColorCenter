//
//  ColorScience.m
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/21.
//

#import "ColorScience.h"


@interface ColorScience ()
@property (strong, nonatomic) NSDictionary * sdToXyzCache;

@end


@implementation ColorScience

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.sdToXyzCache = @{};
    }
    return self;
    
}


- (DoubleShape *)buildSpectroData:(NSArray *)data start:(int)start interval:(int)interval
{
    DoubleShape * doubleShape = [[DoubleShape alloc] init];
    doubleShape.start  = start;
    doubleShape.interval = interval;
    doubleShape.values = data;
    return doubleShape;
}





@end
