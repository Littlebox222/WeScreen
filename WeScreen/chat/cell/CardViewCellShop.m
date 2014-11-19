//
//  CardViewCell.m
//  WeScreen
//
//  Created by Littlebox on 11/17/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import "CardViewCellShop.h"

@interface CardViewCellShop ()

@property (copy, nonatomic) void (^shopButtonPressedBlock)(id sender);

@end

@implementation CardViewCellShop

- (void)dealloc {
    
    [_avaterImageView release];
    [_nameLabel release];
    [_detailLabel release];
    [_shopButton release];
    [_priceLabel release];
    
    [super dealloc];
}

- (void)awakeFromNib {
    [self.shopButton addTarget:self action:@selector(shopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shopButtonPressed:(id)sender {
    
    if (self.shopButtonPressedBlock) {
        self.shopButtonPressedBlock(sender);
    }
}

@end
