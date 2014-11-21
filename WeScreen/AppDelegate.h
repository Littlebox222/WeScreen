//
//  AppDelegate.h
//  WeScreen
//
//  Created by Littlebox on 14-10-3.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUser1      @"3775796348452870" //xiaochuan
#define kUser2      @"3775796952432647" //shenyong
#define kUser3      @"3775797149564936" //kaixin
#define kUser4      @"3775797241839625" //feifan
#define kUser5      @"3775805919854603" //wangxin
#define kCardVote   @"0"
#define kCardShop   @"1"

#define kCurrentUserID ((AppDelegate *)[[UIApplication sharedApplication] delegate]).uid

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *uid;

@end

