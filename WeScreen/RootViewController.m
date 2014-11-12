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

#define kMaxRadius 160

@interface RootViewController ()

@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) PulsingLayer *pulsingLayer;
@property (nonatomic, retain) CAShapeLayer *arcLayer;
@property (nonatomic, retain) UIImageView *startPointView;

@end

@implementation RootViewController

- (void)dealloc {
    [_button release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", @"返回") style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Show View" forState:UIControlStateNormal];
    self.button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    
    self.pulsingLayer = [PulsingLayer layer];
    self.pulsingLayer.position = CGPointMake(rect.size.width/2,rect.size.height/2-20);
    [self.view.layer addSublayer:self.pulsingLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.arcLayer = [CAShapeLayer layer];
    self.arcLayer.path = path.CGPath;
    self.arcLayer.fillColor = [UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1].CGColor;
    self.arcLayer.strokeColor = [UIColor colorWithRed:1.0f green:0.7f blue:0.2f alpha:1.0f].CGColor;
    self.arcLayer.lineWidth = 6;
    self.arcLayer.frame = self.view.frame;
    [self.view.layer addSublayer:self.arcLayer];
    [self drawLineAnimation:self.arcLayer];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(showView:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 5;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)showView:(id)sender {
    
    [self.pulsingLayer removeAllAnimations];
    [self.pulsingLayer removeFromSuperlayer];
    [self.arcLayer removeAllAnimations];
    [self.arcLayer removeFromSuperlayer];
    
    MainViewController *mainViewController = [[[MainViewController alloc] init] autorelease];
    mainViewController.topic = @"微屏互动测试2";
    [self.navigationController pushViewController:mainViewController animated:YES];
}

@end
