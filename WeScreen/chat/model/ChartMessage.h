//
//  ChartMessage.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "UserInfo.h"

typedef enum {
  
    kMessageFrom = 0,
    kMessageTo,
    kMessageCardVote,
    kMessageCardShop
 
}ChartMessageType;

@interface ChartMessage : NSObject

@property (nonatomic,assign) ChartMessageType messageType;

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDictionary *dict;
@property (assign) NSInteger likeNum;
@property (nonatomic, copy) NSString *topic;

@property (nonatomic, retain) UserInfo *userInfo;

@end
