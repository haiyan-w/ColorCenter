//
//  StandardSample.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/15.
//

#import "StandardSample.h"
#import "ColorSpace.h"
#import "ColorScience.h"
#import "BleTool.h"

@implementation ColorData

@end

@implementation FlashDegrees

@end



@implementation StandardSample

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        if (data.length == 2048) {
            //标样解析
            int offset = 8;
            char number[10];
            [data getBytes:number range:NSMakeRange(offset, 10)];
            self.number = [NSString stringWithUTF8String:number];
            
            offset = 18;
            NSData * timedata = [data subdataWithRange:NSMakeRange(offset, 7)];
            int16_t year = [BleTool unsignedDataTointWithData:timedata Location:0 Offset:2];
            int8_t month = [BleTool unsignedDataTointWithData:timedata Location:2 Offset:1];
            int8_t day = [BleTool unsignedDataTointWithData:timedata Location:3 Offset:1];
            int8_t hour = [BleTool unsignedDataTointWithData:timedata Location:4 Offset:1];
            int8_t minute = [BleTool unsignedDataTointWithData:timedata Location:5 Offset:1];
            int8_t second = [BleTool unsignedDataTointWithData:timedata Location:6 Offset:1];
            self.dateTime = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",year,month,day,hour,minute,second];
            
            offset += 7;
            offset += 1; //跳过无用字节
            
            self.angles = [BleTool unsignedDataTointWithData:data Location:offset Offset:2];
            offset += 2;
            
            ColorPanel * panel = [[ColorPanel alloc] init];
            NSMutableArray * angles = [NSMutableArray array];
            
            for (int i = 0; i < 12; i++) {
                NSData * aSciData = [data subdataWithRange:NSMakeRange(offset, 62)];
                
                if ((i == 1) || (i == 3) || (i == 5)) {
                    
                    NSMutableArray * dataArray = [NSMutableArray array];
                    for (int j = 0; j < 31; j++) {
                        uint16_t color = [BleTool unsignedDataTointWithData:aSciData Location:2*j Offset:2];
                        [dataArray addObject:[NSNumber numberWithInt:color]];
                    }
                    ColorPanelAngle * colorPanelAngle = [self colorPanelAngleWith:dataArray];
                    
                    switch (i) {
                        case 1:
                        {
                            colorPanelAngle.angle = [NSNumber numberWithInt:15];
                        }
                            break;
                        case 3:
                        {
                            colorPanelAngle.angle = [NSNumber numberWithInt:45];
                        }
                            break;
                        case 5:
                        {
                            colorPanelAngle.angle = [NSNumber numberWithInt:110];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    [angles addObject:colorPanelAngle];
                    
                }
                offset += 62;
            }
            
            panel.angles = angles;
            
            offset += 28*12;
            
            float granularity = 0;
            
            for (int y = 0; y < 6; y++) {
                NSData * aFlashDegreeData = [data subdataWithRange:NSMakeRange(offset, 16)];
                FlashDegrees * aFlashDegree = [[FlashDegrees alloc] init];
                aFlashDegree.S_i = [BleTool dataToFloat:aFlashDegreeData Location:4*0];
                aFlashDegree.S_a = [BleTool dataToFloat:aFlashDegreeData Location:4*1];
                aFlashDegree.S_G = [BleTool dataToFloat:aFlashDegreeData Location:4*2];
                aFlashDegree.G = [BleTool dataToFloat:aFlashDegreeData Location:4*3];
                
                if (0 == y) {
                    granularity = aFlashDegree.G;
                }else {
                    aFlashDegree.G = granularity;
                }
                
                offset += 16;
            }
            
            panel.graininess = granularity;
            
            self.colorPanel = panel;
            
        }else {
            //数据不完整
        }

    }
    return self;
}


- (ColorPanelAngle *)colorPanelAngleWith:(NSArray <NSNumber *>*)dataArray
{
    ColorPanelAngle * angel = [[ColorPanelAngle alloc] init];
    
    NSMutableArray * doubleArray = [NSMutableArray array];
    for (int j = 0; j < dataArray.count; j++) {
        NSNumber * number = dataArray[j];
        [doubleArray addObject:[NSNumber numberWithDouble:number.intValue/10000.0]];
        switch (j) {
            case 0:
            {
                angel.nm400 = number;
            }
                break;
            case 1:
            {
                angel.nm410 = number;
            }
                break;
            case 2:
            {
                angel.nm420 = number;
            }
                break;
            case 3:
            {
                angel.nm430 = number;
            }
                break;
            case 4:
            {
                angel.nm440 = number;
            }
                break;
            case 5:
            {
                angel.nm450 = number;
            }
                break;
            case 6:
            {
                angel.nm460 = number;
            }
                break;
            case 7:
            {
                angel.nm470 = number;
            }
                break;
            case 8:
            {
                angel.nm480 = number;
            }
                break;
            case 9:
            {
                angel.nm490 = number;
            }
                break;
            case 10:
            {
                angel.nm500 = number;
            }
                break;
            case 11:
            {
                angel.nm510 = number;
            }
                break;
            case 12:
            {
                angel.nm520 = number;
            }
                break;
            case 13:
            {
                angel.nm530 = number;
            }
                break;
            case 14:
            {
                angel.nm540 = number;
            }
                break;
            case 15:
            {
                angel.nm550 = number;
            }
                break;
            case 16:
            {
                angel.nm560 = number;
            }
                break;
            case 17:
            {
                angel.nm570 = number;
            }
                break;
            case 18:
            {
                angel.nm580 = number;
            }
                break;
            case 19:
            {
                angel.nm590 = number;
            }
                break;
            case 20:
            {
                angel.nm600 = number;
            }
                break;
            case 21:
            {
                angel.nm610 = number;
            }
                break;
            case 22:
            {
                angel.nm620 = number;
            }
                break;
            case 23:
            {
                angel.nm630 = number;
            }
                break;
            case 24:
            {
                angel.nm640 = number;
            }
                break;
            case 25:
            {
                angel.nm650 = number;
            }
                break;
            case 26:
            {
                angel.nm660 = number;
            }
                break;
            case 27:
            {
                angel.nm670 = number;
            }
                break;
            case 28:
            {
                angel.nm680 = number;
            }
                break;
            case 29:
            {
                angel.nm690 = number;
            }
                break;
            case 30:
            {
                angel.nm700 = number;
            }
                break;
                
            default:
                break;
        }
    }
    
    ColorSpace * colorSpace = [self colorDataToColorSpace:doubleArray];
    angel.labA = [NSNumber numberWithDouble:colorSpace.labch.a];
    angel.labB = [NSNumber numberWithDouble:colorSpace.labch.b];
    angel.labC = [NSNumber numberWithDouble:colorSpace.labch.c];
    angel.labL = [NSNumber numberWithDouble:colorSpace.labch.l];
    angel.labH = [NSNumber numberWithDouble:colorSpace.labch.h];
    
    angel.xyzX = [NSNumber numberWithDouble:colorSpace.xyz.x];
    angel.xyzY = [NSNumber numberWithDouble:colorSpace.xyz.y];
    angel.xyzZ = [NSNumber numberWithDouble:colorSpace.xyz.z];
    
    angel.rgbB = [NSNumber numberWithInt:colorSpace.rgb.b];
    angel.rgbR = [NSNumber numberWithInt:colorSpace.rgb.r];
    angel.rgbG = [NSNumber numberWithInt:colorSpace.rgb.g];
    return angel;
}

- (ColorSpace *)colorDataToColorSpace:(NSArray *)data
{
    ColorScience * colorScience = [[ColorScience alloc] init];
    DoubleShape * doubleShape = [colorScience buildSpectroData:data start:400 interval:10];
    ColorSpace * colorSpace = [doubleShape toColorSpace];
//    NSLog(@"ColorSpace : L : %f A:%f  B:%f", colorSpace.labch.l, colorSpace.labch.a, colorSpace.labch.b);
    return colorSpace;
}


@end
