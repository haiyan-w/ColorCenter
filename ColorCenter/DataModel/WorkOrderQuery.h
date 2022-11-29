//
//  WorkOrderQuery.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"
#import "LookUp.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderQuery : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,copy) NSString * assignees;
@property(nonatomic,readwrite,copy) NSString * body;
@property(nonatomic,readwrite,copy) NSString * businessDatetime;
@property(nonatomic,readwrite,copy) NSString * cellphone;
@property(nonatomic,readwrite,strong) LookUp * chargingStandard;
@property(nonatomic,readwrite,copy) NSString * colorCode;
@property(nonatomic,readwrite,strong) LookUp * colorEffect;
@property(nonatomic,readwrite,strong) LookUp * colorFamily;
@property(nonatomic,readwrite,copy) NSString * colorName;
@property(nonatomic,readwrite,strong) NSNumber * colorUsage;
@property(nonatomic,readwrite,copy) NSString * comment;
@property(nonatomic,readwrite,copy) NSString * commitFailureReason;
@property(nonatomic,readwrite,copy) NSString * committedDatetime;
@property(nonatomic,readwrite,strong) NSNumber * costRate;
@property(nonatomic,readwrite,strong) LookUp * firstSurface;
@property(nonatomic,readwrite,strong) LookUp * measuringType;
@property(nonatomic,readwrite,strong) LookUp * paintModifying;
@property(nonatomic,readwrite,strong) LookUp * paintType;
@property(nonatomic,readwrite,copy) NSString * plateNo;
@property(nonatomic,readwrite,copy) NSString * preparedBy;
@property(nonatomic,readwrite,copy) NSString * preparedDatetime;
@property(nonatomic,readwrite,strong) NSNumber * price;
@property(nonatomic,readwrite,copy) NSNumber * primeCost;
@property(nonatomic,readwrite,strong) LookUp * rework;
@property(nonatomic,readwrite,copy) NSString * serialNo;
@property(nonatomic,readwrite,copy) NSString * serviceSerialNo;
@property(nonatomic,readwrite,strong) NSNumber * serviceId;
@property(nonatomic,readwrite,strong) LookUp * serviceStatus;
@property(nonatomic,readwrite,strong) LookUp * serviceTerminalType;
@property(nonatomic,readwrite,copy) NSString * serviceTerminalVersion;
@property(nonatomic,readwrite,copy) NSString * sprayDatetime;
@property(nonatomic,readwrite,strong) NSNumber * square;
@property(nonatomic,readwrite,strong) LookUp * status;
@property(nonatomic,readwrite,copy) NSString * surfaceCodes;
@property(nonatomic,readwrite,copy) NSString * surfaceMessage;
@property(nonatomic,readwrite,strong) LookUp * surfaceModifying;
@property(nonatomic,readwrite,copy) NSString * tenantJoinDate;
@property(nonatomic,readwrite,copy) NSString * tenantShortName;
@property(nonatomic,readwrite,copy) NSString * vehicleSpec;
@property(nonatomic,readwrite,copy) NSString * vin;
@property(nonatomic,readwrite,strong) LookUp * warrantyStatus;
@property(nonatomic,readwrite,copy) NSString * workingTeam;
@property(nonatomic,readwrite,copy) NSNumber * year;

@end

NS_ASSUME_NONNULL_END
