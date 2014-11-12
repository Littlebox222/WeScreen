//
//  ThreadViewCellTableViewCell.m
//  WeScreen
//
//  Created by hanchao on 14-10-27.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import "ThreadViewCellTableViewCell.h"

@implementation ThreadViewCellTableViewCell

-(id)init{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]) {
        //
    }
    
    return self;
}

- (void)awakeFromNib {
    
    //
}

- (void)initViews{
    
    if (self.chartMessage){
        //self.avaterImageView.image = [UIImage imageNamed:self.chartMessage.icon];
        //self.nameLabel.text = self.chartMessage.name;
        self.dateLabel.text = @"09-28 10:59";
        self.contentLabel.text = self.chartMessage.content;
        
        CGSize maxSize = CGSizeMake(200, MAXFLOAT);
        
        CGRect labelRect = [self.contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil];
        self.contentLabel.frame = labelRect;
        self.contentLabel.numberOfLines = labelRect.size.height / self.contentLabel.font.lineHeight;
    }
}

-(void)setChartMessage:(ChartMessage *)chartMessage
{
    [_chartMessage release];
    _chartMessage = nil;
    _chartMessage = [chartMessage retain];
    
    [self initViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.avaterImageView = nil;
    self.nameLabel = nil;
    self.dateLabel = nil;
    self.contentLabel = nil;
    
    [super dealloc];
}

@end
