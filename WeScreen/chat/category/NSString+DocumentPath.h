//
//  NSString+DocumentPath.h
//  气泡
//
//  Created by zzy on 14-5-15.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DocumentPath)
+(NSString *)documentPathWith:(NSString *)fileName;
@end

@interface NSString (NSString_Extended)
- (NSString *)urlencode;
@end