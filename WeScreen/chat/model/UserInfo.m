//
//  UserInfo.m
//  WeScreen
//
//  Created by Littlebox on 11/11/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize uid = _uid;
@synthesize name = _name;
@synthesize iconUrl = _iconUrl;
@synthesize iconNum = _iconNum;

- (void)dealloc {
    
    [_uid release];
    [_name release];
    [_iconUrl release];
    
    [super dealloc];
}

- (id)initWithDict:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self) {
        
        self.name = dict[@"name"];
        self.uid = [dict[@"id"] stringValue];
        self.iconNum = [dict[@"icon"] integerValue];
        
        self.iconUrl = [dict[@"icon_url"] lastPathComponent];
    }
    
    return self;
}

@end
