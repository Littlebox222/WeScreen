//
//  MenuView.h
//  WeScreen
//
//  Created by Littlebox on 14-10-11.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property (nonatomic, retain) UILabel *groupName;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

- (void)setSelected;
- (void)setUnselected;

@end
