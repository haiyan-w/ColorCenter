//
//  SortView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/3/15.
//

#import "SortView.h"
#import "UIColor+CustomColor.h"
#import "PopViewController.h"


@interface SortView()
@property(nonatomic,readwrite,strong) UILabel * label;
@property(nonatomic,readwrite,strong) UIButton * button;
@property(nonatomic,readwrite,strong) UIImageView * icon;

@property(nonatomic,readwrite,assign) CGRect orgFrame;
@end

@implementation SortView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor bgWhiteColor];
    self.layer.masksToBounds = YES;
    [self viewInit];
    self.maxLenth = 90;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.orgFrame = frame;
        self.backgroundColor = [UIColor bgWhiteColor];
        self.layer.cornerRadius = frame.size.height/2.0;
        self.layer.masksToBounds = YES;
        [self viewInit];
        self.maxLenth = 90;
        self.layoutDirction = Layout_Right;
    }
    return self;
}

-(void)viewInit
{
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 16 - 4), (self.frame.size.height - 16)/2, 16, 16)];
    self.icon.image = [UIImage imageNamed:@"triangle"];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(8, (self.frame.size.height - 20)/2, 20, 20)];
    self.label.textColor = [UIColor textColor];
    self.label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    self.button = [[UIButton alloc] initWithFrame:self.bounds];
    [self.button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.icon];
    [self addSubview:self.label];
    [self addSubview:self.button];
    
    [self layoutSelf];
}


-(void)layoutSelf
{
    [self.label sizeToFit];
    
    CGFloat labW = 20;
    if (self.label.frame.size.width > (self.maxLenth - 32)) {
        labW = (self.maxLenth - 32);
    }else if (self.label.frame.size.width < 20) {
        labW = 20;
    }else {
        labW = self.label.frame.size.width;
    }
    CGFloat viewW = labW + 32;
    
    if (Layout_Right == self.layoutDirction) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, viewW, self.frame.size.height);
    }else {
        CGFloat endX = self.orgFrame.origin.x + self.orgFrame.size.width;
        self.frame = CGRectMake((endX - viewW), self.frame.origin.y, viewW, self.frame.size.height);
    }
    
    self.label.frame = CGRectMake(8, (self.frame.size.height-20)/2, labW, 20);
    self.icon.frame = CGRectMake((self.frame.size.width - 16 - 4), (self.frame.size.height - 16)/2, 16, 16);
    self.button.frame = self.bounds;
}

-(void)setText:(NSString *)text
{
    self.label.text = text;
    [self layoutSelf];
}


-(void)setItems:(NSArray<LookUp *> *)items
{
    _items = items;
    
    self.curItem = [items firstObject];
}

-(void)setCurItem:(LookUp *)curItem
{
    _curItem = curItem;
    [self setText:curItem.message];
}

-(void)buttonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnClickedOn:)] ) {
        [self.delegate  btnClickedOn:self];
    }else {
        NSMutableArray * strings = [NSMutableArray array];
        for (LookUp * item in self.items) {
            [strings addObject:item.message];
        }
        
        PopViewController * popCtrl = [[PopViewController alloc] initWithTitle:self.title?self.title:@"选择" Data:strings];
        
        __weak typeof(self) weakSelf = self;
        popCtrl.selectBlock = ^(NSInteger index, NSString * _Nonnull string) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.curItem = strongSelf.items[index];
            if (strongSelf.changeBlock) {
                strongSelf.changeBlock(strongSelf.curItem);
            }
           
        };
        [popCtrl showIn:self.viewCtrl];
    }
}

@end
