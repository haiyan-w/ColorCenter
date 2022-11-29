//
//  SearchTextView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/9/2.
//

#import "SearchTextView.h"
#import "SearchTag.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"
#import "UIFont+CustomFont.h"

@interface SearchTextView () <UITextFieldDelegate>
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIView * tagView;
@property (strong, nonatomic) NSMutableArray <SearchTag *>* tagViews;
@end

@implementation SearchTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 18;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor borderColor].CGColor;
    
    self.scrollView  = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    
    self.tagView = [[UIView alloc] init];
    [self.scrollView addSubview:self.tagView];
    
    self.textField = [[UITextField alloc] init];
//    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.textField.returnKeyType = UIReturnKeySearch;
    [self.textField addTarget:self action:@selector(searchTextChanged) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:self.textField];
}


-(void)layoutSubviews
{
    [super layoutSubviews];

    self.scrollView.frame = CGRectMake(6, 0, self.width - 2*6, self.height);
    self.tagView.frame = CGRectMake(0, (self.height - 24)/2, [self widthWithTagViews], 24);
    
    float minTFWidth = 48;
    float tfwidth = self.scrollView.width - self.tagView.width - 6;
    if (tfwidth < minTFWidth) {
        tfwidth = minTFWidth;
    }
    
    self.textField.frame = CGRectMake(self.tagView.right+6, 2, tfwidth, self.bounds.size.height - 2*2);

    float tagX = 0;
    for (SearchTag * tag in self.tagViews) {
        tag.frame = CGRectMake(tagX, 0, tag.width, 24);
        tagX += tag.width + 4;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.textField.right, self.scrollView.height);
    if (self.scrollView.contentSize.width > self.scrollView.width) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width - self.scrollView.width, 0);
    }
    
}

- (void)searchTextChanged
{
    if (self.textChangedBlock) {
        self.textChangedBlock([self getText]);
    }
}


- (NSString *)getText
{
    NSMutableString * string = [NSMutableString string];
    if (self.tags.count > 0) {
        NSString * tagString = [self stringWithTags:self.tags];
        [string appendString:tagString];
    }
    [string appendString:self.textField.text];
    return string;
}


- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
//    self.textField.delegate = delegate;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.textField.placeholder = placeHolder;
}

- (void)setTags:(NSArray *)tags
{
    _tags = tags;
    
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    [self clearTagView];

    float space = 4;
    float orgX = 0;
    self.tagViews = [NSMutableArray array];
    for (int i = 0; i < tags.count; i++) {
        __block NSString * text = tags[i];
        CGSize size = [SearchTag sizeWithText:text];
        __block SearchTag * tag = [[SearchTag alloc] initWithFrame:CGRectMake(orgX + space, (self.height - 24)/2, size.width, 24)];
        tag.text = text;
        [self.tagView addSubview:tag];
        [self.tagViews addObject:tag];
        
        __weak typeof(self) weakSelf = self;
        tag.deleteBlk = ^{
            __strong typeof(self) strongSelf = weakSelf;
            NSMutableArray * array = [NSMutableArray arrayWithArray:strongSelf.tags];
            [array removeObjectAtIndex:i];
            strongSelf.tags = array;
        };
    }
    
    [self searchTextChanged];
    
    [self layoutSubviews];
}

- (void)clearTagView
{
    for (SearchTag * tag in self.tagViews) {
        [tag removeFromSuperview];
    }
    [self.tagViews removeAllObjects];
}


- (float)widthWithTagViews
{
    float space = 4;
    float width = 0;
    
    for (int i = 0; i < self.tagViews.count; i++) {
        SearchTag * tag = self.tagViews[i];
        width += tag.width + space;
    }

    return width;
}

- (float)widthWithTags
{
    float space = 4;
    float width = 0;
    
    for (int i = 0; i < self.tags.count; i++) {
        NSString * text = self.tags[i];
        CGSize size = [SearchTag sizeWithText:text];
        if (i != 0) {
            width += space;
        }
        width += size.width;
    }

    return width;
}


#pragma mark Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.tags.count > 0) {
        NSString * text = [self stringWithTags:self.tags];
        self.tags = @[];
        self.textField.text = [NSString stringWithFormat:@"%@ ",text];
        
        UITextPosition * pos = [self.textField endOfDocument];
        self.textField.selectedTextRange = [self.textField textRangeFromPosition:pos toPosition:pos];
        [self.textField becomeFirstResponder];
    }else {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.returnBlock) {
        self.returnBlock([self getText]);
    }
    
    return YES;
}


- (NSString *)stringWithTags:(NSArray *)tags
{
    NSMutableString * string = [NSMutableString string];
    for (NSString * tag in tags) {
        if (string.length > 0) {
            [string appendString:@" "];
        }
        [string appendString:tag];
    }
    return string;
}

@end
