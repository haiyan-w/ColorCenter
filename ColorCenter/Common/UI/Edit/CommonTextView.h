//
//  CommonTextView.h
//  EnochCar
//
//  Created by 王海燕 on 2021/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  CommonTextView;
@protocol CommonTextViewDelegate <NSObject>

@optional

-(void)commonTextViewBeginEditing:(CommonTextView*)textview;

-(void)commonTextViewEndEditing:(CommonTextView*)textview;

-(void)commonTextView:(CommonTextView*)textview didTextChanged:(NSString*)text;

@end

@interface CommonTextView : UIView
@property (nonatomic,nullable,weak) id<CommonTextViewDelegate> delegate;
@property (nonatomic,copy) NSString * titleStr;
@property (nonatomic,strong) NSString * placeHolder;
@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) BOOL border;
@property (nonatomic,assign) BOOL hideTextNumber;
@property (nonatomic,assign) NSInteger maxTextNumber;//最大字数（默认300）

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)titleStr placeHolder:(NSString *)placeHolderStr;
-(void)setFrame:(CGRect)frame;
-(NSString*)getText;
-(void)setText:(NSString*)text;
-(void)setTextViewTag:(NSInteger)tag;
-(void)beginEditing;
-(void)endEditing;
//-(void)removeMonitor;

- (BOOL)isFirstResponder;
@end

NS_ASSUME_NONNULL_END
