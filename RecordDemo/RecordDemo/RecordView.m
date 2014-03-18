//
//  RecordView.m
//  RecordDemo
//
//  Created by tiewang on 14-2-28.
//  Copyright (c) 2014年 tiewang. All rights reserved.
//

#import "RecordView.h"

@implementation RecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.layer.cornerRadius = 9.0f;
        [self initilization];
    }
    return self;
}

-(void)initilization{
    //初始化音量peak峰值图片数组
    peakImageAry = [[NSArray alloc]initWithObjects:
                    
                    [UIImage imageNamed:@"RecordingSignal001.png"],
                    [UIImage imageNamed:@"RecordingSignal002.png"],
                    [UIImage imageNamed:@"RecordingSignal003.png"],
                    [UIImage imageNamed:@"RecordingSignal004.png"],
                    [UIImage imageNamed:@"RecordingSignal005.png"],
                    [UIImage imageNamed:@"RecordingSignal006.png"],
                    [UIImage imageNamed:@"RecordingSignal007.png"],
                    [UIImage imageNamed:@"RecordingSignal008.png"],
                    nil];
}

#pragma mark -还原显示界面
- (void)restoreDisplay{
    //还原录音图
    _peakMeterIV.image = [peakImageAry objectAtIndex:0];
    //停止震动
   
}

#pragma mark - 更新音频峰值
- (void)updateMetersByAvgPower:(float)_avgPower{
    //-160表示完全安静，0表示最大输入值
    //
    NSLog(@"meter...%f",_avgPower);
    NSInteger imageIndex = 0;
    if (_avgPower >= -120 && _avgPower < -35)
        imageIndex = 0;
    else if (_avgPower >= -35 && _avgPower < -30)
        imageIndex = 1;
    else if (_avgPower >= -25 && _avgPower <-20)
        imageIndex = 2;
    else if (_avgPower >= -20 && _avgPower <-18)
        imageIndex = 3;
    else if (_avgPower >= -18 && _avgPower <-15)
        imageIndex = 4;
    else if (_avgPower >= -15 && _avgPower <-10)
        imageIndex = 5;
    else if (_avgPower >= -10 && _avgPower <-5)
        imageIndex = 6;
    else if (_avgPower >= -5 && _avgPower <0)
        imageIndex = 7;
   
    
    _peakMeterIV.image = [peakImageAry objectAtIndex:imageIndex];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
