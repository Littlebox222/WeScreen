//
//  LoginViewController.m
//  WeScreen
//
//  Created by Littlebox on 12/16/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RootViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"选择用户登录";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button1.frame = CGRectMake(20, 80, self.view.frame.size.width/1.5, 30);
//    [button1 setTitle:@"User1: 陈翔家的小天" forState:UIControlStateNormal];
//    [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
//    [button1 addTarget:self action:@selector(button1Pressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(20, 80*2, self.view.frame.size.width/1.5, 30);
    [button2 setTitle:@"User2: Catherine_Ren" forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [button2 addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
//    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button3.frame = CGRectMake(20, 80*3, self.view.frame.size.width/1.5, 30);
//    [button3 setTitle:@"User3: 菁菁无悔" forState:UIControlStateNormal];
//    [button3.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
//    [button3 addTarget:self action:@selector(button3Pressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button3];
    
//    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button4.frame = CGRectMake(20, 80*4, self.view.frame.size.width/1.5, 30);
//    [button4 setTitle:@"User4: fudanchen" forState:UIControlStateNormal];
//    [button4.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
//    [button4 addTarget:self action:@selector(button4Pressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button4];

//    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button5.frame = CGRectMake(20, 80*5, self.view.frame.size.width/1.5, 30);
//    [button5 setTitle:@"User5: 雪之夏沫" forState:UIControlStateNormal];
//    [button5.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
//    [button5 addTarget:self action:@selector(button5Pressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button5];
}


- (void)button1Pressed:(UIButton *)button {

    kCurrentUserID = kUser1;
    RootViewController *rootViewController = [[[RootViewController alloc] init] autorelease];
    [self.navigationController pushViewController:rootViewController animated:YES];
}

- (void)button2Pressed:(UIButton *)button {
    
    kCurrentUserID = kUser2;
    RootViewController *rootViewController = [[[RootViewController alloc] init] autorelease];
    [self.navigationController pushViewController:rootViewController animated:YES];
}

- (void)button3Pressed:(UIButton *)button {
    
    kCurrentUserID = kUser3;
    RootViewController *rootViewController = [[[RootViewController alloc] init] autorelease];
    [self.navigationController pushViewController:rootViewController animated:YES];
}

- (void)button4Pressed:(UIButton *)button {
    
    kCurrentUserID = kUser4;
    RootViewController *rootViewController = [[[RootViewController alloc] init] autorelease];
    [self.navigationController pushViewController:rootViewController animated:YES];
}

- (void)button5Pressed:(UIButton *)button {
    
    kCurrentUserID = kUser5;
    RootViewController *rootViewController = [[[RootViewController alloc] init] autorelease];
    [self.navigationController pushViewController:rootViewController animated:YES];
}

@end
