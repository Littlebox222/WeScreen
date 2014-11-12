//
//  UserInfo.h
//  WeScreen
//
//  Created by Littlebox on 11/11/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import <Foundation/Foundation.h>

//{"id":3775796348452870,"name":"xiaochuan","icon":1,"icon_url":"/Users/Littlebox/Downloads/icons/xiaochuan.jpg"}

@interface UserInfo : NSObject

@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconUrl;
@property (assign) NSInteger iconNum;

- (id)initWithDict:(NSDictionary *)dict;

@end
