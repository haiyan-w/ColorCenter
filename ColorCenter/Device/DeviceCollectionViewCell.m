//
//  DeviceCollectionViewCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import "DeviceCollectionViewCell.h"


@interface DeviceCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *statusLab;



@end

@implementation DeviceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

- (void)setSpectro:(Spectro *)spectro
{
    _spectro = spectro;
    
    self.nameLab.text = spectro.name;
}

- (void)setIsConnected:(BOOL)isConnected
{
    _isConnected = isConnected;
    
    self.statusLab.hidden = !isConnected;
}

@end
