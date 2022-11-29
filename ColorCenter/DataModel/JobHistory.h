//
//  JobHistory.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "BaseModel.h"
#import "LookUp.h"
#import "Formula.h"

NS_ASSUME_NONNULL_BEGIN

@class Job;

@interface JobHistory : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,strong) NSArray <FormulaDetail *> * details;
@property(nonatomic,readwrite,strong) LookUp * status;
@property(nonatomic,readwrite,strong) LocalDateTime * preparedDatetime;
@property(nonatomic,readwrite,strong) Formula * formula;
@property(nonatomic,readwrite,strong) Job * job;
@property(nonatomic,readwrite,strong) Formula * referencedFormula;



- (BOOL)isFinished;
@end

NS_ASSUME_NONNULL_END
