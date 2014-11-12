//
//  ChartMessage.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartMessage.h"
#import "AppDelegate.h"

@implementation ChartMessage

@synthesize mid = _mid;
@synthesize time = _time;
@synthesize content = _content;
@synthesize dict = _dict;
@synthesize topic = _topic;
@synthesize likeNum = _likeNum;
@synthesize userInfo = _userInfo;

- (void)dealloc {
    
    [_mid release];
    [_time release];
    [_content release];
    [_dict release];
    [_topic release];
    [_userInfo release];
    
    [super dealloc];
}

- (void)setDict:(NSDictionary *)dict
{
    if (_dict) {
        [_dict release];
    }
    _dict = [dict retain];
    
    self.mid = dict[@"id"];
    self.time = dict[@"create_time"];
    self.content = dict[@"content"];
    self.topic = dict[@"topic"];
    self.likeNum = dict[@"like:"] ? [dict[@"like:"] integerValue] : 0;
    
    self.userInfo = [[[UserInfo alloc] initWithDict:dict[@"user"]] autorelease];
    
    if ([self.userInfo.uid isEqualToString:kCurrentUserID]) {
        self.messageType = kMessageTo;
    }else {
        self.messageType = kMessageFrom;
    }
}

@end
