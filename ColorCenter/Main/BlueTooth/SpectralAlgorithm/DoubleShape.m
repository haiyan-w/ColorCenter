//
//  DoubleShape.m
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/21.
//

#import "DoubleShape.h"
#import "LagrangeCoefficientsType.h"
#import "DoubleArrayShape.h"





@implementation DoubleShape




- (ColorSpace *)toColorSpace
{
    IlluminantType * illuminantType = [[IlluminantType alloc] initD65];
    CmfsType * cmfsType = [[CmfsType alloc] initCIE10D];
    Xyz2LabIlluminant * xyz2LabIlluminant = [[Xyz2LabIlluminant alloc] initXYZ2LABCH_10_D65];
    
    ColorSpace * colorSpace = [[ColorSpace alloc] init];
    colorSpace.xyz = [self toXyz:illuminantType cmfsType:cmfsType];
    colorSpace.labch = [colorSpace.xyz toLabch:xyz2LabIlluminant];
    colorSpace.rgb = [colorSpace.labch toRgb];
    
    return colorSpace;
    
}


- (Xyz *)toXyz:(IlluminantType *)illuminantType cmfsType:(CmfsType *)cmfsType
{
    DoubleArrayShape * doubleArrayShape = [self doubleArrayShapeWith:illuminantType cmfsType:cmfsType];

    double xyz[3];
    xyz[0] = 0.0;
    xyz[1] = 0.0;
    xyz[2] = 0.0;
    
    for (int i = self.start; i <= [self end]; i += self.interval) {
        NSNumber * value = [self getValue:i];
        if (value == NULL) {
            value = [NSNumber numberWithDouble:0.0];
        }
        
        NSArray * doubleArray = [doubleArrayShape getValue:i];
        for (int j = 0; j < doubleArray.count; j++) {
            NSNumber * d = doubleArray[j];
            double oldvalue = xyz[j];
            xyz[j] = oldvalue + d.doubleValue * value.doubleValue;
        }
        
    }
    
    Xyz * xyzObj = [[Xyz alloc] init];
    
    xyzObj.x = xyz[0];
    xyzObj.y = xyz[1];
    xyzObj.z = xyz[2];
    
    return xyzObj;
}

- (DoubleArrayShape *)doubleArrayShapeWith:(IlluminantType *)illuminantType cmfsType:(CmfsType *)cmfsType
{
    DoubleArrayShape * doubleArrayShape = [[DoubleArrayShape alloc] init];
    int maxStart = (illuminantType.start > cmfsType.start)?illuminantType.start:cmfsType.start;
    int illuminantend = [illuminantType end];
    int cmfsend = [cmfsType end];
    int minEnd =  (illuminantend > cmfsend)?cmfsend:illuminantend;
    int minInterval = (illuminantType.interval < cmfsType.interval)?illuminantType.interval:cmfsType.interval;
    
    int len = ((minEnd - maxStart) / self.interval + 1);
    NSMutableArray * w = [NSMutableArray array];
    for (int i =0; i < len; i++) {
        NSMutableArray * array = [NSMutableArray arrayWithObjects:@0.0,@0.0,@0.0, nil];
        [w addObject:array];
    }

    NSMutableArray * s = [NSMutableArray array];
    for (int i = maxStart; i <= minEnd; i=i+minInterval) {
        [s addObject:[illuminantType getValue:i]];
    }
    
    NSMutableArray * y = [NSMutableArray array];
    for (int i = maxStart; i <= minEnd; i=i+minInterval) {
        [y addObject:[cmfsType getValue:i]];
    }
    
    int index = 0;
    for (int i = maxStart; i <= minEnd; i=i+self.interval) {
        NSArray * cmfs = [cmfsType getValue:i];
        NSNumber * illuminant = [illuminantType getValue:i];
        if (illuminant == NULL) {
            illuminant = [NSNumber numberWithDouble:0.0];
        }

        NSMutableArray * cmfsMap = [NSMutableArray array];
        for (int j = 0; j < cmfs.count; j++) {
            NSNumber * cmfsValue = cmfs[j];
            double mapvalue = cmfsValue.doubleValue * illuminant.doubleValue;
            [cmfsMap addObject:[NSNumber numberWithDouble:mapvalue]];
        }
        
        w[index] = cmfsMap;
        
        index ++;
    }
    
    
    NSArray <NSArray *> * c_c = [self lagrangeCoefficientsASTME2022:self.interval type:BOUNDARY];
    
    NSArray <NSArray *> * c_b = [self lagrangeCoefficientsASTME2022:self.interval type:INNER];

    NSUInteger w_c = y.count;
    NSUInteger r_c = c_b.count;
    NSUInteger w_lif = w_c - (w_c - 1) % self.interval - 1 - r_c;
    
    NSUInteger i_c = w.count;
    NSUInteger i_cm = i_c - 1;
    
    
    for (int i =0; i < 3; i++) {
        
        for (int j =0; j < r_c; j++) {
            
            for (int k =0; k < 3; k++) {
                NSNumber * wki = w[k][i];
                NSNumber * cjk = c_c[j][k];
                NSNumber * sj = s[j + 1];
                NSNumber * yji = y[j + 1][i];
                
                NSMutableArray * array = w[k];
                array[i] = [NSNumber numberWithDouble:wki.doubleValue + cjk.doubleValue * sj.doubleValue * yji.doubleValue];
            }
        }
        
        for (int j =0; j < r_c; j++) {
            
            for (int k = i_cm; k > i_cm - 2; k--) {
                NSNumber * wki = w[k][i];
                NSNumber * crcjik = c_c[r_c - j - 1][i_cm - k];
                NSNumber * sj = s[j + w_lif];
                NSNumber * yji = y[j + w_lif][i];
                NSMutableArray * array = w[k];
                array[i] = [NSNumber numberWithDouble:wki.doubleValue + crcjik.doubleValue * sj.doubleValue * yji.doubleValue];
            }
            
        }
        
        for (int j =0; j < (i_c - 3); j++) {
            
            for (int k =0; k < r_c; k++) {
                int w_i = (r_c + 1) * (j + 1) + 1 + k;
                
                NSNumber * wji = w[j][i];
                NSNumber * cbk = c_b[k][0];
                NSNumber * swi = s[w_i];
                NSNumber * ywii = y[w_i][i];
                w[j][i] = [NSNumber numberWithDouble:wji.doubleValue + cbk.doubleValue * swi.doubleValue * ywii.doubleValue];
                
                wji = w[j + 1][i];
                cbk = c_b[k][1];
                w[j + 1][i] = [NSNumber numberWithDouble:wji.doubleValue + cbk.doubleValue * swi.doubleValue * ywii.doubleValue];
                
                wji = w[j + 2][i];
                cbk = c_b[k][2];
                w[j + 2][i] = [NSNumber numberWithDouble:wji.doubleValue + cbk.doubleValue * swi.doubleValue * ywii.doubleValue];
                
                wji = w[j + 3][i];
                cbk = c_b[k][3];
                w[j + 3][i] = [NSNumber numberWithDouble:wji.doubleValue + cbk.doubleValue * swi.doubleValue * ywii.doubleValue];
                
            }
        }
        
        for (int j = w_c - ((w_c - 1) % self.interval); j < w_c; j++) {
            NSNumber * wii = w[i_cm][i];
            NSNumber * sj = s[j];
            NSNumber * yii = y[j][i];
            w[i_cm][i] = [NSNumber numberWithDouble:wii.doubleValue + sj.doubleValue * yii.doubleValue];
        }
        
    }
    
    double sum = 0;
    for (NSArray * array in w) {
        NSNumber * value = array[1];
        sum += value.doubleValue;
    }
    double k = 100 / sum;
    
    NSMutableArray * wmapArray = [NSMutableArray array];
    for (NSArray * array in w) {
        NSMutableArray * mapValues = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSNumber * value = array[i];
            [mapValues addObject:[NSNumber numberWithDouble:value.doubleValue * k]];
        }
        [wmapArray addObject:mapValues];
    }
    
    w = wmapArray;
    
    int firstIndex = (self.start - maxStart) / self.interval;
    int lastIndex = firstIndex + (int)self.values.count;
    
    NSMutableArray * firstIndexArray = [NSMutableArray arrayWithArray:w[firstIndex]];
    for (int i = 0; i < firstIndex; i++) {
        NSArray * array = w[i];
        for (int j = 0; j < array.count; j++) {
            NSNumber * value = array[j];
            NSNumber * oldvalue = firstIndexArray[j];
            firstIndexArray[j] = [NSNumber numberWithDouble:value.doubleValue + oldvalue.doubleValue];
        }
    }
    w[firstIndex] = firstIndexArray;
    
    NSMutableArray * lastIndexArray = [NSMutableArray arrayWithArray:w[lastIndex-1]];
    for (int i = (int)w.count-1; i >= lastIndex; i--) {
        NSArray * array = w[i];
        for (int j = 0; j < array.count; j++) {
            NSNumber * value = array[j];
            NSNumber * oldvalue = lastIndexArray[j];
            lastIndexArray[j] = [NSNumber numberWithDouble:value.doubleValue + oldvalue.doubleValue];
        }
    }
    w[lastIndex-1] = lastIndexArray;
    
    
    doubleArrayShape.start = maxStart;
    doubleArrayShape.interval = self.interval;
    doubleArrayShape.values = w;
    
    return doubleArrayShape;
}


- (NSArray *)lagrangeCoefficientsASTME2022:(int )interval type:(LagrangeCoefficientsType)type
{
    NSMutableArray * result = [NSMutableArray array];
    int size = interval - 1;
    double t = 1.0 / interval;
    
    int i = 0;
    while (i < size) {
        double dd =  t * (i + 1);
        [result addObject:[NSNumber numberWithDouble:dd]];
        i++;
    }
    
    int d = 3;
    if (type == INNER) {
        i = 0;
        while (i < size) {
            NSNumber * dd =  result[i];
            result[i] = [NSNumber numberWithDouble:dd.doubleValue +1];
            i++;
        }
        d = 4;
    }
    
    NSMutableArray * r_i = [NSMutableArray array];
    for (int i = 0; i < d; i++) {
        [r_i addObject:[NSNumber numberWithInt:i]];
    }
    
    NSMutableArray * resultArray = [NSMutableArray array];
    for (int r = 0; r < result.count; r++) {
        NSNumber * rValue = result[r];
        
        NSMutableArray * totalArray = [NSMutableArray array];
        for (int j = 0; j < r_i.count; j++) {
            
            NSMutableArray * filterArray = [NSMutableArray array];
            for (int k = 0; k < r_i.count; k++) {
                NSNumber * kValue = r_i[k];
                if (j != kValue.intValue) {
                    [filterArray addObject:kValue];
                }
            }
            
            for (int i = 0; i < filterArray.count; i++) {
                NSNumber * iValue = filterArray[i];
                double mapValue = (rValue.doubleValue - iValue.intValue)/(j -  iValue.intValue);
                filterArray[i] = [NSNumber numberWithDouble:mapValue];
            }
            
            double total = 1;
            for (int m = 0; m < filterArray.count; m++) {
                NSNumber * mValue = filterArray[m];
                total  = total * mValue.doubleValue;
            }
            [totalArray addObject:[NSNumber numberWithDouble:total]];
        }
        
        [resultArray addObject:totalArray];
    }
    
    return resultArray;
    
}


- (NSNumber *)getValue:(int)pos
{
    int diffPos = pos - self.start;
    NSNumber * value = NULL;
    
    if ((diffPos % self.interval == 0)) {
        value = self.values[diffPos/self.interval];
        
    }else {
        int leftIndex = diffPos / self.interval;
        
        if (leftIndex > 0 && leftIndex < (self.values.count-1)) {
            NSNumber * left = self.values[leftIndex];
            NSNumber * right = self.values[leftIndex+1];
            double diff = right.doubleValue - left.doubleValue;
            double delta = diff/self.interval;
            
            double valuedd = left.doubleValue + delta * (diffPos%self.interval);
            
            value = [NSNumber numberWithDouble:valuedd];
        }
    }
    
    return value;
}

 
@end
