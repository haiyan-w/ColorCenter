//
//  JobFormulaQuery.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"
#import "ColorPanelAngle.h"

NS_ASSUME_NONNULL_BEGIN

@interface JobFormulaQuery : BaseModel
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle15;
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle45;
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle110;
@property(nonatomic,readwrite,copy) NSString * colorCode;
@property(nonatomic,readwrite,copy) NSString * colorName;
@property(nonatomic,readwrite,strong) NSNumber * formulaId;
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,strong) NSNumber * score;
@property(nonatomic,readwrite,copy) NSString * vehicleSpec;
@property(nonatomic,readwrite,strong) NSNumber * year;
@end

NS_ASSUME_NONNULL_END
