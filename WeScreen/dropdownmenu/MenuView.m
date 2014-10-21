//
//  MenuView.m
//  WeScreen
//
//  Created by Littlebox on 14-10-11.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

@synthesize groupName = _groupName;

- (void)dealloc {
    
    [_groupName release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.groupName = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.groupName.text = title;
        self.groupName.font = [UIFont boldSystemFontOfSize:18];
        self.groupName.textColor = [UIColor whiteColor];
        self.groupName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.groupName];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)setSelected {
    
}
- (void)setUnselected {
    
}

@end
