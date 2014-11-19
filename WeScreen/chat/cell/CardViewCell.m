//
//  CardViewCell.m
//  WeScreen
//
//  Created by Littlebox on 11/17/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import "CardViewCell.h"

@interface CardViewCell ()

@property (copy, nonatomic) void (^supportButtonPressedBlock)(id sender);

@end

@implementation CardViewCell

- (void)dealloc {
    
    [_avaterImageView release];
    [_nameLabel release];
    [_detailLabel release];
    [_supportButton release];
    
    [super dealloc];
}

- (void)awakeFromNib {
    
    [self.supportButton addTarget:self action:@selector(supportButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)supportButtonPressed:(id)sender {
    
    if (self.supportButtonPressedBlock) {
        self.supportButtonPressedBlock(sender);
    }
}

@end
