//
//  VideoViewController.h
//  EnochCar
//
//  Created by HAIYAN on 2021/5/7.

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class VideoViewController;
@protocol VideoViewControllerDelegate <NSObject>

@optional
-(void)videoViewController:(VideoViewController*)videoCtrl takeImage:(UIImage *)image;
-(void)videoViewController:(VideoViewController*)videoCtrl takeVideo:(NSURL *)url;
@end

//typedef void(^TakeOperationSureBlock)(id item);
typedef void(^TakeOperationSureBlock)(PHAsset * asset);

@interface VideoViewController : UIViewController
//@property(weak, nonatomic) id<VideoViewControllerDelegate>delegate;

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

//可录制最长时间
@property (assign, nonatomic) NSInteger HSeconds;

@end
