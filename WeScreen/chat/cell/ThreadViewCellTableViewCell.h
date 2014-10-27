//
//  ThreadViewCellTableViewCell.h
//  WeScreen
//
//  Created by hanchao on 14-10-27.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartMessage.h"

@interface ThreadViewCellTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *avaterImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *contentLabel;

@property (nonatomic, retain) ChartMessage *chartMessage;

-(id)init;

@end
