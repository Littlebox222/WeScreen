//
//  CardView.h
//  WeScreen
//
//  Created by Littlebox on 11/17/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

extern NSString *kCardTypeVote;
extern NSString *kCardTypeShop;

@interface CardView : UIView <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>

@property (nonatomic, retain) NSString *cardType;
@property (nonatomic, retain) UIImageView *adView;
@property (nonatomic, retain) UITableView *tableView;

- (id)initWithFrame:(CGRect)frame type:(NSString *)type;
- (void)updateTableView;
@end
