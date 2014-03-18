//
//  RootViewController.h
//  RecordDemo
//
//  Created by tiewang on 14-2-28.
//  Copyright (c) 2014年 tiewang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *recordList;
- (IBAction)recording:(id)sender;
@end
