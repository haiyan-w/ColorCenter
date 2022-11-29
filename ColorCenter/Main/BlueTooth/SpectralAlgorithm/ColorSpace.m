//
//  ColorSpace.m
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/25.
//

#import "ColorSpace.h"
#import "DoubleArrayShape.h"

@implementation Xyz

- (Labch *)toLabch:(Xyz2LabIlluminant *)xyz2LabIlluminant
{
    Labch * labch = [[Labch alloc] init];
    
    NSNumber * x_n = xyz2LabIlluminant.values[0];
    NSNumber * y_n = xyz2LabIlluminant.values[1];
    NSNumber * z_n = xyz2LabIlluminant.values[2];
    
    double fx = [self intermediateLightnessCIE1976:self.x y_n:x_n.doubleValue];
    double fy = [self intermediateLightnessCIE1976:self.y y_n:y_n.doubleValue];
    double fz = [self intermediateLightnessCIE1976:self.z y_n:z_n.doubleValue];
    
    double l = 116 * fy - 16;
    double a = 500 * (fx - fy);
    double b = 200 * (fy - fz);
    
    double c = sqrt(a * a + b * b);
    double h = 0.0;
    
    if (a == 0.0 && b > 0) {
        h = 90.0;
        
    }else if (a == 0.0 && b < 0) {
        h = 270.0;
        
    }else if (a >= 0 && b == 0.0) {
        h = 0.0;
    }else if (a < 0 && b == 0.0) {
        h = 180.0;
    }else {
        double dd = 0.0;
        if (a > 0 && b > 0) {
            dd = 0.0;
        }else if (a < 0) {
            dd = 180.0;
        } else {
            dd = 360.0;
        }
        
        h = atan(b/a)* 57.3 + dd;
    }
    
    labch.l = l;
    labch.a = a;
    labch.b = b;
    labch.c = c;
    labch.h = h;
    
    return labch;
}


- (double)intermediateLightnessCIE1976:(double)Y y_n:(double)Y_N
{
    double it = Y/Y_N;
    double comparedd = pow(24.0/116, 3.0);
    double result = 0.0;
    if (it > comparedd) {
        result = pow(it, 1.0/3);
    }else {
        result = (841.0 / 108) * it + 16.0 / 116;
    }
    return result;
}

@end

@implementation Labch

- (Rgb *)toRgb
{
    double y = (self.l + 16.0) / 116.0;
    double x = self.a / 500.0 + y;
    double z = y - self.b / 200.0;
    
    if (y > 6.0 / 29){
        y = pow(y,3.0);
    }else {
        y =(y - 16.0 / 116) / 7.787;
    }
    
    if (x > 6.0 / 29){
        x = pow(x,3.0);
    }else {
        x = (x - 16.0 / 116) / 7.787;
    }
    
    if (z > 6.0 / 29){
        z = pow(z,3.0);
    }else {
        z = (z - 16.0 / 116) / 7.787;
    }
    
    x *= 0.95047;
    z *= 1.08883;
    
    double rgb_r = 3.2406 * x - 1.5372 * y - 0.4986 * z;
    double rgb_g = -0.9689 * x + 1.8758 * y + 0.0415 * z;
    double rgb_b = 0.0557 * x - 0.2040 * y + 1.0570 * z;
    
    if (rgb_r > 0.0031308){
        rgb_r = 1.055 * pow(rgb_r,1/2.4)- 0.055;
        
    }else {
        rgb_r = 12.92 * rgb_r;
    }
    
    if (rgb_g > 0.0031308){
        rgb_g =  1.055 * pow(rgb_g, 1/2.4) - 0.055;
    }  else{
        rgb_g = 12.92 * rgb_g;
    }
    
    if (rgb_b > 0.0031308){
        rgb_b = 1.055 * pow(rgb_b, 1/2.4) - 0.055;
    }  else {
        rgb_b = 12.92 * rgb_b;
    }
    
    Rgb * rgb = [[Rgb alloc] init];
    rgb.r = (int)(rgb_r * 255);
    rgb.r = (rgb.r > 255)?255:rgb.r;
    rgb.r = (rgb.r < 0)?0:rgb.r;
    
    rgb.g = (int)(rgb_g * 255);
    rgb.g = (rgb.g > 255)?255:rgb.g;
    rgb.g = (rgb.g < 0)?0:rgb.g;
    
    rgb.b = (int)(rgb_b * 255);
    rgb.b = (rgb.b > 255)?255:rgb.b;
    rgb.b = (rgb.b < 0)?0:rgb.b;
    
    return rgb;
}

@end

@implementation Rgb

@end


@implementation ColorSpace


@end
