//
//  FormulaQuery.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "BaseModel.h"
#import "LookUp.h"
#import "ColorPanelAngle.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormulaQuery : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle15;
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle45;
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle110;
@property(nonatomic,readwrite,copy) NSString * colorCode;
@property(nonatomic,readwrite,copy) NSString * colorName;
@property(nonatomic,readwrite,strong) LookUp *paintType;
@property(nonatomic,readwrite,strong) LocalDateTime * preparedDateTime;
@property(nonatomic,readwrite,strong) LookUp * procedureType;
@property(nonatomic,readwrite,copy) NSString * serialNo;
@property(nonatomic,readwrite,strong) LookUp * status;
@property(nonatomic,readwrite,copy) NSString * type;
@property(nonatomic,readwrite,copy) NSString * vehicleBrand;
@property(nonatomic,readwrite,copy) NSString * vehicleSpec;
@property(nonatomic,readwrite,strong) NSArray <NSString *>* vehicleSpecs;
@property(nonatomic,readwrite,strong) NSNumber * year;
@end

NS_ASSUME_NONNULL_END
