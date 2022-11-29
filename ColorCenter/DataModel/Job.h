//
//  Job.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "BaseModel.h"
#import "LookUp.h"
#import "User.h"
#import "JobHistory.h"
#import "ColorPanel.h"
#import "WorkOrderQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface Job : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,copy) NSString * colorCode;
@property(nonatomic,readwrite,copy) NSString * colorName;
@property(nonatomic,readwrite,strong) ColorPanel * colorPanel;
@property(nonatomic,readwrite,strong) LookUp * favorite;
@property(nonatomic,readwrite,strong) NSNumber * formulaId;
@property(nonatomic,readwrite,strong) JobHistory * lastJobHistory;
@property(nonatomic,readwrite,strong) User * owner;
@property(nonatomic,readwrite,strong) User * preparedBy;
@property(nonatomic,readwrite,strong) LocalDateTime * preparedDatetime;
@property(nonatomic,readwrite,copy) NSString * serialNo;
@property(nonatomic,readwrite,strong) WorkOrderQuery * sprayWorkOrder;
@property(nonatomic,readwrite,strong) LookUp * status;
@property(nonatomic,readwrite,strong) NSArray <NSString *> * vehicleSpec;
@property(nonatomic,readwrite,strong) NSNumber * year;


- (BOOL)isFinished;
@end

NS_ASSUME_NONNULL_END
