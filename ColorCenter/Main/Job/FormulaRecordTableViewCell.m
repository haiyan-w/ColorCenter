//
//  FormulaRecordTableViewCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import "FormulaRecordTableViewCell.h"
#import "Job.h"
#import "UIColor+CustomColor.h"

@interface FormulaRecordTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *point;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *subLab;
@property (strong, nonatomic) IBOutlet UILabel *unfinishedLab;
@property (strong, nonatomic) IBOutlet UILabel *finishedLab;
@end

@implementation FormulaRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.point.layer.cornerRadius = 2.0;
    self.finishedLab.layer.cornerRadius = 8.0;
    self.finishedLab.layer.borderColor = [UIColor tintColor].CGColor;
    self.finishedLab.layer.borderWidth = 1;
    self.finishedLab.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJobHistory:(JobHistory *)jobHistory
{
    _jobHistory = jobHistory;
    
    self.nameLab.text = [NSString stringWithFormat:@"%@/%@",self.jobHistory.job.colorName,self.jobHistory.job.colorCode];
    self.subLab.text = self.jobHistory.preparedDatetime;
    
    [self refreshStatus];
}

- (void)setIsJobFinished:(BOOL)isJobFinished
{
    _isJobFinished = isJobFinished;
    
    [self refreshStatus];
}

- (void)refreshStatus
{
    BOOL isHistoryFinished = [self.jobHistory isFinished];
    
    self.unfinishedLab.hidden = self.isJobFinished && !isHistoryFinished;
    self.finishedLab.hidden = !(self.isJobFinished && isHistoryFinished);   
}

@end
