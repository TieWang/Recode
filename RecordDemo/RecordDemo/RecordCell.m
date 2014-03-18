//
//  RecordCell.m
//  RecordDemo
//
//  Created by tiewang on 14-2-28.
//  Copyright (c) 2014年 tiewang. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)awakeFromNib{
    UIImage *image = [[UIImage imageNamed:@"SenderVoiceNodeBkg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
    [_playIcon setBackgroundImage:image  forState: UIControlStateNormal];
    [self initilization];
}

-(void)initilization{
    //初始化音量peak峰值图片数组
    peakImageAry = [[NSArray alloc]initWithObjects:
                    [UIImage imageNamed:@"SenderVoiceNodePlaying000.png"],
                    [UIImage imageNamed:@"SenderVoiceNodePlaying001.png"],
                    [UIImage imageNamed:@"SenderVoiceNodePlaying002.png"],
                    [UIImage imageNamed:@"SenderVoiceNodePlaying003.png"], nil];
}
#pragma mark -还原显示界面
- (void)restoreDisplay{
    //还原录音图
    [_playIcon setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"] forState:UIControlStateNormal];
    //停止震动
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)play:(id)sender {
    
}

#pragma mark - 更新音频峰值
- (void)updateMetersByAvgPower:(float)_avgPower{
    //-160表示完全安静，0表示最大输入值
    //
    NSLog(@"meter...%f",_avgPower);
    NSInteger imageIndex = 0;
    if (_avgPower >= -120 && _avgPower < -30)
        imageIndex = 0;
    else if (_avgPower >= -30 && _avgPower < -20)
        imageIndex = 1;
    else if (_avgPower >= -20 && _avgPower <-10)
        imageIndex = 2;
    else if (_avgPower >= -10 && _avgPower <0)
        imageIndex = 3;
    [_playIcon setImage:[peakImageAry objectAtIndex:imageIndex] forState:UIControlStateNormal ];
}


@end
