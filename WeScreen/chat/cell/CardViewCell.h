//
//  CardViewCell.h
//  WeScreen
//
//  Created by Littlebox on 11/17/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *avaterImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailLabel;
@property (nonatomic, retain) IBOutlet UIButton *supportButton;

- (void)setSupportButtonPressedBlock:(void (^)(id sender))supportButtonPressedBlock;

@end
