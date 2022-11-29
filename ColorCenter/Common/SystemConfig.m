//
//  SystemConfig.m
//  EnochCar
//
//  Created by 王海燕 on 2021/9/24.
//

#import "SystemConfig.h"
#import "NetWorkAPIManager.h"
#import "SystemAttribute.h"
#import "UIView+Hint.h"
#import "CommonTool.h"


@interface SystemConfig()
//@property(nonatomic,copy) NSArray<SystemAttribute*> * branchAttributes;//系统所有配置项
@end

@implementation SystemConfig

static SystemConfig * systemConfig;


+(instancetype)defaultSystemConfig
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        systemConfig = [[SystemConfig alloc] init];
    });
    
    return systemConfig;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [self getBranchAttributes];
       
    }
    return self;
}

-(void)getBranchAttributes
{
    __weak typeof(self) weakSelf = self;
    
    [[NetWorkAPIManager defaultManager] getBranchAttributeSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        NSDictionary * resp = responseObject;
        NSArray * data = [resp objectForKey:@"data"];
        
       NSMutableArray * allAttributes = [NSMutableArray array];
        for (NSDictionary * dic in data) {
            [allAttributes addObject:[[SystemAttribute alloc] initWithDictionary:dic]];
        }
//        weakself.branchAttributes = allAttributes;
        
        for (SystemAttribute * attribute in allAttributes) {
            NSString * code = attribute.id.code;
            
            //项目计价方式
            if ([code isEqualToString:@"SVMTVLM"]) {
                strongSelf.chargeMethodCode = attribute.value;
            }
            
            //额定工时单价
            if ([code isEqualToString:@"SVMLBHPRC"]) {
                strongSelf.price = attribute.value;
            }
            
            //是否必须派工
            if ([code isEqualToString:@"FRCASN"]) {
                if ([attribute.value isEqualToString:@"Y"]) {
                    strongSelf.needEngineer = YES;
                }else {
                    strongSelf.needEngineer = NO;
                }
            }
            
            //默认保养间隔（月）
            if ([code isEqualToString:@"MATINT"]) {
                strongSelf.maintenanceDateInterval = [attribute.value integerValue];
            }
            
            //默认保养里程
            if ([code isEqualToString:@"MATMIL"]) {
                strongSelf.maintenanceMileageInterval = [attribute.value floatValue];
            }
            
            //项目配件折扣显示（P：正向 N：反向）
            if ([code isEqualToString:@"SVCDISRSH"]) {
                if ([attribute.value isEqualToString:@"P"]) {
                    strongSelf.discountForward = YES;
                }else {
                    strongSelf.discountForward = NO;
                }
            }
            
            //维修工单自动抹零
            if ([code isEqualToString:@"SRVAOTERS"]) {
                if ([attribute.value isEqualToString:@"Y"]) {
                    strongSelf.zeroErasing = YES;
                }else {
                    strongSelf.zeroErasing = NO;
                }
            }
            
            //配件打折
            if ([code isEqualToString:@"SVCGDISPH"]) {
                if ([attribute.value isEqualToString:@"MR"]) {
                    //出库打折
                    strongSelf.isGoodsWarehouseDiscount = YES;
                }else {
                    //ST：结算打折
                    strongSelf.isGoodsWarehouseDiscount = NO;
                }
            }
            
        }
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

@end
