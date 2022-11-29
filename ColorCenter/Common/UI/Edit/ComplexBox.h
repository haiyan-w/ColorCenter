//
//  ComplexBox.h
//  EnochCar
//
//  Created by 王海燕 on 2021/7/9.
//

#import <UIKit/UIKit.h>
//#import "CommonType.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum{
    ComplexBoxEdit,
    ComplexBoxSelect,
    ComplexBoxEditAndSelect
}ComplexBoxMode;

typedef enum{
    ComplexBoxQueryNull,
    ComplexBoxQueryHint,
    ComplexBoxQueryLookup
}QueryMode;

typedef enum{
    ComplexBoxInput_NoCheck,
    ComplexBoxInput_Int,
    ComplexBoxInput_Cellphone,
    ComplexBoxInput_Percent,//百分比，0-100保留两位小数
    ComplexBoxInput_Float2Digit
}InputCheckMode;

typedef void(^ComplexBoxSelectBlock)(void);
typedef BOOL (^ComplexBoxInputCheckBlock)(NSString * string);

@class  ComplexBox;
@protocol ComplexBoxDelegate <NSObject>

@optional

- (BOOL)complexBoxShouldBeginEditing:(ComplexBox*)box;

- (void)complexBoxBeginEditing:(ComplexBox*)box;

- (BOOL)complexBox:(ComplexBox*)box shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (void)complexBoxViewEndEditing:(ComplexBox*)box;

- (void)complexBox:(ComplexBox*)box didTextChanged:(NSString*)text;


@end


@interface ComplexBoxItem : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * popTitle;
@property (nonatomic,assign) ComplexBoxMode mode;
@property (nonatomic,assign) QueryMode queryMode;
@property (nonatomic,assign) InputCheckMode inputCheckMode;
@property (nonatomic,copy) NSString * queryCode;
@property (nonatomic,assign) BOOL isRequired;
@property (nonatomic,assign) BOOL enabled;

@end



@interface ComplexBox : UIView
@property (nullable,nonatomic,weak) id<UITextFieldDelegate> delegate;
@property (nullable,nonatomic,weak) id<ComplexBoxDelegate> boxDelegate;
@property (nullable, nonatomic,copy) ComplexBoxSelectBlock selectBlock;
@property (nonatomic,weak) UIViewController * viewController;

@property (nonatomic,assign) QueryMode queryMode;
@property (nonatomic,copy) NSString * hint;
@property (nonatomic,copy) NSString * lookup;
@property (nonatomic,copy) NSString * popTitle;

@property (nonatomic,assign) InputCheckMode inputCheckMode;
@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) BOOL isRequired;//是否必填项：YES显示红色*

@property (nonatomic,strong,nullable) ComplexBoxItem * boxItem;

@property (nonatomic,strong) UIColor * borderColor;
@property (nonatomic,strong) UIColor * boxBgColor;//输入框底色
@property(nonatomic) UIKeyboardType keyboardType;

-(instancetype)initWithFrame:(CGRect)frame mode:(ComplexBoxMode)mode;

-(instancetype)initWithFrame:(CGRect)frame mode:(ComplexBoxMode)mode title:(NSString * _Nullable)title;
-(instancetype)initWithFrame:(CGRect)frame mode:(ComplexBoxMode)mode title:(NSString *_Nullable)title hint:(NSString *)hint  popTitle:(NSString *)popTitle;
-(instancetype)initWithFrame:(CGRect)frame mode:(ComplexBoxMode)mode title:( NSString * _Nullable)title lookup:(NSString *)lookup  popTitle:(NSString *)popTitle;

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

-(void)setMode:(ComplexBoxMode)mode;
-(void)setText:(NSString*)text;
-(NSString*)getText;
-(void)setItem:(id)item;
-(id)getSelectedItem;

-(NSString*)getTitle;

- (void)setBoxItem:(ComplexBoxItem * _Nullable)boxItem;

-(void)setBorderColor:(UIColor*)borderColor;
-(void)setRightStr:(NSString *)rightStr;
-(void)setRightImageName:(NSString *)imageName;

-(void)setPlaceHolder:(NSString * _Nullable)placeHolder;

@end

NS_ASSUME_NONNULL_END
