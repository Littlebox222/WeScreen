//
//  AppDelegate.h
//  WeScreen
//
//  Created by Littlebox on 14-10-3.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define kUser1      @"3775796348452870" //xiaochuan
//#define kUser2      @"3775796952432647" //shenyong
//#define kUser3      @"3775797149564936" //kaixin
//#define kUser4      @"3775797241839625" //feifan
//#define kUser5      @"3788385639989251" //chenxiang
//#define kUser6      @"3775805919854603" //wangxin

#define kUser1      @"3788782974795784" //陈翔家的小天
#define kUser2      @"3788785373937674" //Catherine_Ren
#define kUser3      @"3788788305756176" //菁菁无悔
#define kUser4      @"3788788511277073" //fudanchen
#define kUser5      @"3788788708409362" //雪之夏沫
#define kUser6      @"3775796348452870" //xiaochuan
#define kUser7      @"3775796952432647" //shenyong
#define kUser8      @"3775797149564936" //kaixin
#define kUser9      @"3775797241839625" //feifan
#define kUser10      @"3775805919854603" //wangxin
#define kUser11      @"3789159241613359" //笨笨跳跳小白兔
#define kUser12      @"3789159384219696" //方块小鱼
#define kUser13      @"3789159497465905" //箐公子
#define kUser14      @"3789159602323506" //sophia王亚
#define kUser15      @"3789159719764019" //Yes_MyLady_
#define kUser16      @"3789161703669813" //龍妹妹mua


#define kCardVote   @"0"
#define kCardShop   @"1"

#define kCurrentUserID ((AppDelegate *)[[UIApplication sharedApplication] delegate]).uid

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *uid;

@end

