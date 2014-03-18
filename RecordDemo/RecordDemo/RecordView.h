//
//  RecordView.h
//  RecordDemo
//
//  Created by tiewang on 14-2-28.
//  Copyright (c) 2014年 tiewang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordView : UIView
{
    NSArray         *peakImageAry;
}
@property (strong, nonatomic) IBOutlet UIImageView *peakMeterIV;
- (void)restoreDisplay;
- (void)updateMetersByAvgPower:(float)_avgPower;
@end
