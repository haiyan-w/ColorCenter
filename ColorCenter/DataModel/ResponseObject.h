//
//  ResponseObject.h
//  EnochCar
//
//  Created by 王海燕 on 2022/6/23.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface ConfirmedOption : BaseModel
@property(nonatomic,readwrite,strong) NSString * code;
@property(nonatomic,readwrite,strong) NSString * message;
@property(nonatomic,readwrite,strong) NSNumber * primary;
@end


@interface Confirmation : BaseModel
@property(nonatomic,readwrite,strong) NSString * code;
@property(nonatomic,readwrite,strong) ConfirmedOption * confirmedOption;
@property(nonatomic,readwrite,strong) NSNumber * doubleCheck;
@property(nonatomic,readwrite,strong) NSString * message;
@property(nonatomic,readwrite,strong) NSArray <NSString *> * options;
@property(nonatomic,readwrite,strong) NSArray <NSString *> * parameters;
@end


@interface Paging : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * itemCount;
@property(nonatomic,readwrite,strong) NSNumber * pageCount;
@property(nonatomic,readwrite,strong) NSNumber * pageIndex;
@property(nonatomic,readwrite,strong) NSNumber * pageSize;
@end


@interface Meta : BaseModel
@property(nonatomic,readwrite,strong) Paging * paging;
@property(nonatomic,readwrite,strong) NSArray <NSString *> * sessionKeys;
@end


@interface Error : BaseModel
@property(nonatomic,readwrite,strong) NSString * code;
@property(nonatomic,readwrite,strong) NSString * message;
@property(nonatomic,readwrite,strong) NSArray <NSString *> * parameters;
@property(nonatomic,readwrite,strong) NSString * reason;
@end


@interface Warning : BaseModel
@property(nonatomic,readwrite,strong) NSString * code;
@property(nonatomic,readwrite,strong) NSString * message;
@property(nonatomic,readwrite,strong) NSArray <NSString *> * parameters;
@end


@interface ResponseObject : BaseModel
@property(nonatomic,readwrite,strong) NSArray <Confirmation *> * confirmations;
@property(nonatomic,readwrite,strong) NSArray * data;
@property(nonatomic,readwrite,strong) NSArray <Error *>* errors;
@property(nonatomic,readwrite,strong) Meta * meta;
@property(nonatomic,readwrite,strong) NSDictionary * extraData;
@property(nonatomic,readwrite,strong) NSArray <Warning *> * warnings;
@end










NS_ASSUME_NONNULL_END
