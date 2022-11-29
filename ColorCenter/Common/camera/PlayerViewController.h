//
//  PlayerViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2021/7/23.
//

#import <UIKit/UIKit.h>
#import "GestureViewController.h"
//#import "TagViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PlayerCtrlDeleteBlock)(void);
typedef void(^DissmissBlock)(NSString * tag, NSString * comment, BOOL hasModify);

@interface PlayerViewController : UIViewController
@property(copy,nonatomic)PlayerCtrlDeleteBlock deleteBlock;
@property(copy,nonatomic) DissmissBlock dissmissBlock;
@property(nonatomic,assign) BOOL enabled;

-(instancetype)initWithUrl:(NSURL *)url;
-(instancetype)initWithUrl:(NSURL *)url name:(NSString *)name;
//-(instancetype)initWithUrl:(NSURL*)url tag:(NSString*)tagString tagType:(TagType)tagType;
//-(instancetype)initWithUrl:(NSURL*)url tag:(NSString*)tagString tagType:(TagType)tagType comment:(NSString *)comment;
-(void)showOn:(UIViewController*)viewCtrl;
@end

NS_ASSUME_NONNULL_END
