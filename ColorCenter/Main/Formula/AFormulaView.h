//
//  AFormulaView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import <UIKit/UIKit.h>
#import "Formula.h"
#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFormulaView : UIView
@property (strong, nonatomic) Formula * formula;
@property (strong, nonatomic) Job * job;

@property (copy, nonatomic) void (^confirmBlk)(void);
@property (copy, nonatomic) void (^adjustBlk)(void);


+ (float)heightWithFormula:(Formula *)formula;
@end

NS_ASSUME_NONNULL_END
