//
//  RecordListView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import <UIKit/UIKit.h>
#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordListView : UIView
@property (weak, nonatomic) Job * job;
@property (weak, nonatomic) UIViewController * viewCtrl;
@end

NS_ASSUME_NONNULL_END
