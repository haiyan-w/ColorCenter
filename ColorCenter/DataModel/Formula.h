//
//  Formula.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/31.
//

#import "BaseModel.h"
#import "LookUp.h"
#import "ColorPanel.h"
#import "FormulaDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface Formula : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,strong) NSString * colorCode;
@property(nonatomic,readwrite,strong) NSString * colorName;
@property(nonatomic,readwrite,strong) ColorPanel * colorPanel;
@property(nonatomic,readwrite,strong) NSArray <FormulaDetail *> * details;
@property(nonatomic,readwrite,strong) LookUp * paintType;
@property(nonatomic,readwrite,strong) LocalDateTime * preparedDateTime;
@property(nonatomic,readwrite,strong) LookUp * procedureType;
@property(nonatomic,readwrite,strong) NSString * serialNo;
@property(nonatomic,readwrite,strong) LookUp * status;
@property(nonatomic,readwrite,strong) LookUp * type;
@property(nonatomic,readwrite,strong) NSString * vehicleBrand;
@property(nonatomic,readwrite,strong) NSArray <NSString *>* vehicleSpec;
@property(nonatomic,readwrite,strong) NSNumber * year;

@end

NS_ASSUME_NONNULL_END
