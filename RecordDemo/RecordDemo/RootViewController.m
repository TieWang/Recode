//
//  RootViewController.m
//  RecordDemo
//
//  Created by tiewang on 14-2-28.
//  Copyright (c) 2014年 tiewang. All rights reserved.
//

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RecordCell.h"
#import "RecordView.h"
@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource,AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioPlayer *_player;
    AVAudioRecorder *_recorder;
    NSMutableArray *_m4aSource;
    RecordView *recorderView;
    NSTimer *timer;
    NSTimer *playerTimer;
}
@property (nonatomic,copy)NSString *currentFilePath;
@property (nonatomic,strong)RecordCell *currentCell;
- (IBAction)playAMR:(id)sender;
@end

@implementation RootViewController
static NSString *ReuseIdentifier = @"record";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _m4aSource = [[NSMutableArray alloc] initWithCapacity:0];
    [_recordList registerNib:[UINib nibWithNibName:@"RecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ReuseIdentifier];
    [_recordList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAMR:(id)sender {
    
}
- (IBAction)recording:(id)sender {
    UILongPressGestureRecognizer *longPressedRecognizer = (UILongPressGestureRecognizer *)sender;
    //长按开始
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        //开始录音
        [self  beginRecord];
        
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
        //停止计时器
        [self stopTimer];
        [recorderView removeFromSuperview];
        //停止录音
        if (_recorder.isRecording)
            [_recorder stop];
        NSString *filePath = [NSString stringWithFormat:@"%@",_currentFilePath];
        [_m4aSource addObject:filePath];
        [_recordList insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_m4aSource count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_recordList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_m4aSource count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}
-(NSString *)getCurrentTimeString{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}
-(NSString *)getPathByFileName:(NSString *)fileName ofType:(NSString *)type{
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   return  [[[paths objectAtIndex:0]stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:type];
}
-(NSDictionary *)getAudioRecorderSettingDict{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 16000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}

#pragma mark - 初始化录音界面
- (void)initRecordView{
    if (recorderView == nil)
        recorderView = (RecordView*)[[[NSBundle mainBundle]loadNibNamed:@"RecordView" owner:self options:nil]lastObject];
    
    //还原界面显示
    [recorderView setCenter:self.view.center];
    [self.view addSubview:recorderView];
    [recorderView restoreDisplay];
}
#pragma mark - 启动定时器
- (void)startTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeter) userInfo:nil repeats:YES];
}
- (void)startPlayerTimer{
    playerTimer =[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updatePlayerMeter) userInfo:nil repeats:YES];
}
#pragma mark - 停止定时器
- (void)stopTimer{
    if (timer && timer.isValid){
        [timer invalidate];
        timer = nil;
    }
}
-(void)stopPlayerTimer{
    [_currentCell restoreDisplay];
    if (playerTimer && playerTimer.isValid){
        [playerTimer invalidate];
        playerTimer = nil;
    }
}
#pragma mark - 更新音频峰值
- (void)updateMeter{
    
    if (_recorder.isRecording){
//        NSLog(@"fffff");
        //更新峰值
        [_recorder updateMeters];
        [recorderView updateMetersByAvgPower:[_recorder averagePowerForChannel:0]];
        //        NSLog(@"峰值:%f",[recorder averagePowerForChannel:0])
    }
}
-(void)updatePlayerMeter{
    if (_player.isPlaying) {
        [_player updateMeters];
        [_currentCell updateMetersByAvgPower:[_player averagePowerForChannel:0]];
    }
}
#pragma mark - 开始录音
-(void)beginRecord{
    NSString *fileName = [self getCurrentTimeString];
    NSString *filePath  =[self getPathByFileName:fileName ofType:@"wav"];
    if (_recorder) {
        [_recorder stop];
        [_recorder setDelegate:nil];
        _recorder = nil;
    }
    
    NSLog(@"file %@",filePath);
    _currentFilePath = filePath;
    _recorder =[[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:filePath] settings:[self getAudioRecorderSettingDict] error:nil];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    
    [_recorder prepareToRecord];
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [_recorder record];
    [self startTimer];
    //显示录音界面
    [self initRecordView];

}
#pragma mark - 开始播放
-(void)beginPlayer:(NSString *)filePath{
    if (_player.isPlaying) {
        [_player stop];
        [_player setDelegate:nil];
        _player =nil;
    }
    _player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
    _player.delegate = self;
    _player.meteringEnabled = YES;
    _player.volume =1.0;
    [_player prepareToPlay];
    //开始播放
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
  
    [_player play];
    [self startPlayerTimer];
   
}
#pragma mark - AVAudioRecorder Delegate Methods
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音停止");
    
    [self stopTimer];
   
}
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"录音开始");
    [self stopTimer];
    
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"录音中断");
    [self stopTimer];
    }

#pragma mark - AVAudioPlayer Delegate Methods
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放终止");
    [self stopPlayerTimer];
    
}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"播放开始");
    [self stopPlayerTimer];
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    NSLog(@"播放中断");
    [self stopPlayerTimer];
}
#pragma mark --UItableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return [_m4aSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
#pragma mark -- tabledelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [_currentCell  restoreDisplay];
    _currentCell =(RecordCell *) [tableView cellForRowAtIndexPath:indexPath];
    [self beginPlayer:[_m4aSource objectAtIndex:indexPath.row]];
    
}
@end
