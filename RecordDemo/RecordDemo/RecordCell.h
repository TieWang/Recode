//
//  RecordCell.h
//  RecordDemo
//
//  Created by tiewang on 14-2-28.
//  Copyright (c) 2014年 tiewang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell{
    NSArray         *peakImageAry;
}

@property (strong, nonatomic) IBOutlet UIButton *playIcon;
@property (unsafe_unretained) id delegate;
- (IBAction)play:(id)sender;
- (void)updateMetersByAvgPower:(float)_avgPower;
- (void)restoreDisplay;
@end
