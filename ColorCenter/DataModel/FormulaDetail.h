//
//  FormulaDetail.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/18.
//

#import "BaseModel.h"
#import "LookUp.h"
#import "Goods.h"

NS_ASSUME_NONNULL_BEGIN

@class Formula;

@interface FormulaDetail : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,strong) Formula * formula;
@property(nonatomic,readwrite,strong) NSNumber * weight;
@property(nonatomic,readwrite,strong) Goods * goods;
@property(nonatomic,readwrite,strong) LookUp * colorLayer;
@end

NS_ASSUME_NONNULL_END
