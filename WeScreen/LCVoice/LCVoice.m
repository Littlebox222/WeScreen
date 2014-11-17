//
//  LCVoice.m
//  LCVoiceHud
//
//  Created by 郭历成 on 13-6-21.
//  Contact titm@tom.com
//  Copyright (c) 2013年 Wuxiantai Developer Team.(http://www.wuxiantai.com) All rights reserved.
//

#import "LCVoice.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - <DEFINES>

#define WAVE_UPDATE_FREQUENCY   0.05

#pragma mark - <CLASS> LCVoice

@interface LCVoice () <AVAudioRecorderDelegate>
{
    NSTimer * timer_;
}

@property (nonatomic, retain) AVAudioRecorder *recorder;

@end

@implementation LCVoice

- (void)dealloc{
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
    self.recordPath = nil;
    
    [super dealloc];
    
}

#pragma mark - Publick Function

- (void)startRecordWithPath:(NSString *)path
{    
    NSError *err = nil;
    
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
	if (err) {
        NSLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
    
	[audioSession setActive:YES error:&err];
    
	err = nil;
	if (err) {
        NSLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
    
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                              [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey, nil];
     
	self.recordPath = path;
	NSURL *url = [NSURL fileURLWithPath:self.recordPath];
	
	err = nil;
	
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
	if (audioData)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
	}
	
	err = nil;
    
    if (self.recorder) {[self.recorder stop];self.recorder = nil;}
    self.recorder = [[[AVAudioRecorder alloc] initWithURL:url settings:settings error:&err] autorelease];
    
	if(!_recorder) {
        NSLog(@"recorder: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	
	[_recorder setDelegate:self];
	[_recorder prepareToRecord];
	_recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (!audioHWAvailable) {
        return;
	}
	
	[_recorder recordForDuration:(NSTimeInterval) 3];
    
    self.recordTime = 0;
    [self resetTimer];
    
	timer_ = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

- (void)stopRecordWithCompletionBlock:(void (^)())completion
{    
    dispatch_async(dispatch_get_main_queue(),completion);

    [self cancelled];
}

#pragma mark - Timer Update

- (void)updateMeters {
    self.recordTime += WAVE_UPDATE_FREQUENCY;
}

#pragma mark - Helper Function

- (void)resetTimer
{    
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

- (void)cancelRecording
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;    
}

- (void)cancelled {
    
    [self resetTimer];
    [self cancelRecording];
}

#pragma mark - LCVoiceHud Delegate

- (void)LCVoiceHudCancelAction
{
    [self cancelled];
}

@end
