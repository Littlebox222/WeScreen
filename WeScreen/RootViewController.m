//
//  RootViewController.m
//  WeScreen
//
//  Created by Littlebox on 14-10-3.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"

#import "PulsingLayer.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "LCVoice.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define kMaxRadius 160
#define kMaxDuration 30

@interface RootViewController ()<ASIHTTPRequestDelegate> {
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
}

@property (nonatomic, retain) PulsingLayer *pulsingLayer;
@property (nonatomic, retain) CAShapeLayer *arcLayer;
@property (nonatomic, retain) UIImageView *startPointView;
@property (nonatomic, retain) LCVoice * voice;
@property (nonatomic, assign) double prob;
@property (nonatomic, assign) int baseTime;

@end

@implementation RootViewController

@synthesize baseTime = _baseTime;
@synthesize prob = _prob;

- (void)dealloc {
    [_voice release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", @"返回") style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.voice = [[[LCVoice alloc] init] autorelease];
    self.prob = 0;
    self.baseTime = 0;
    
    UIImageView *adView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 60)] autorelease];
    adView.image = [UIImage imageNamed:@"search_1.png"];
    adView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:adView];
    
    UIImageView *adView2 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 75, self.view.frame.size.width, 60)] autorelease];
    adView2.image = [UIImage imageNamed:@"search_2.png"];
    adView2.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:adView2];
}

- (void)viewDidAppear:(BOOL)animated {
    
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    
    self.pulsingLayer = [PulsingLayer layer];
    self.pulsingLayer.position = CGPointMake(rect.size.width/2,rect.size.height/2-20);
    [self.view.layer addSublayer:self.pulsingLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:50 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
    self.arcLayer = [CAShapeLayer layer];
    self.arcLayer.path = path.CGPath;
    self.arcLayer.fillColor = [UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1].CGColor;
    self.arcLayer.strokeColor = [UIColor colorWithRed:1.0f green:0.7f blue:0.2f alpha:1.0f].CGColor;
    self.arcLayer.lineWidth = 6;
    self.arcLayer.frame = self.view.frame;
    [self.view.layer addSublayer:self.arcLayer];
    [self drawLineAnimation:self.arcLayer];
    
    [self recordAgain];
    
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(plusTimer)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)plusTimer {
    self.baseTime += 1;
}

- (void)recordStart
{
    [self.voice startRecordWithPath:[NSString stringWithFormat:@"%@/Documents/MySound.wav", NSHomeDirectory()]];
}

- (void)recordEnd
{
    [self.voice stopRecordWithCompletionBlock:^{
        
        if (self.voice.recordTime > 0.0f) {
            
            NSLog(@"%@", self.voice.recordPath);
            
            //TODO:上传音频
            
            NSString *string = [NSString stringWithFormat:@"http://10.75.2.56:8080/topic/rec"];
            NSURL *url = [NSURL URLWithString:string];
            ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
            [request setFile: [NSString stringWithFormat:@"%@", self.voice.recordPath] forKey:@"audio"];
            request.delegate = self;
            request.defaultResponseEncoding = NSUTF8StringEncoding;
            [request startAsynchronous];
        }
        
    }];
}

- (void)recordCancel
{
    [self.voice cancelled];
}

- (void)recordAgain {
    
    [self recordStart];
    
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(recordEnd)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = kMaxDuration;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)showViewWithTopic:(NSString *)topic {
    
    [self.pulsingLayer removeAllAnimations];
    [self.pulsingLayer removeFromSuperlayer];
    [self.arcLayer removeAllAnimations];
    [self.arcLayer removeFromSuperlayer];
    
    MainViewController *mainViewController = [[[MainViewController alloc] init] autorelease];
    mainViewController.topic = topic;
    [self.navigationController pushViewController:mainViewController animated:YES];
}


#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error:nil];
    
    
    NSString *topic = @"";
    double time = 0;
    
    if (json) {
        //topic = @"爸爸去哪儿-1";
        topic = [json objectForKey:@"topic"];
        time = [[json objectForKey:@"time"] doubleValue];
        self.prob = [[json objectForKey:@"score"] doubleValue];
    }
    
    if (self.prob) {
        [self showViewWithTopic:topic];
    }else {
        
        if (self.baseTime > kMaxDuration - 5) {
            self.baseTime = 0;
            self.prob = 0;
        }else {
            [self recordAgain];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
    
    if (self.baseTime > kMaxDuration - 5) {
        
        self.baseTime = 0;
        self.prob = 0;
        
    }else {
        [self recordAgain];
    }
}

@end
