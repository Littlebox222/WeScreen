//
//  RootViewController.m
//  WeScreen
//
//  Created by Littlebox on 14-10-3.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"

@interface RootViewController ()

@property (nonatomic, retain) UIButton *button;

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
    
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showView:(id)sender {
    MainViewController *mainViewController = [[[MainViewController alloc] init] autorelease];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

@end
