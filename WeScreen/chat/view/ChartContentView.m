//
//  ChartContentView.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kContentStartMargin 15
#import "ChartContentView.h"
#import "ChartMessage.h"
@implementation ChartContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
        [self addSubview:self.backImageView];
        
        self.contentLabel=[[UILabel alloc]init];
        self.contentLabel.numberOfLines=0;
        self.contentLabel.textAlignment=NSTextAlignmentLeft;
        self.contentLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:self.contentLabel];

        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)]];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backImageView.frame=self.bounds;
    CGFloat contentLabelX=0;
    if(self.chartMessage.messageType==kMessageFrom){
        contentLabelX=kContentStartMargin*0.8;
        self.contentLabel.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    }else if(self.chartMessage.messageType==kMessageTo){
        contentLabelX=kContentStartMargin*0.5;
        self.contentLabel.textColor = [UIColor whiteColor];
    }
    self.contentLabel.frame=CGRectMake(contentLabelX, 0, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);
}
-(void)longTap:(UILongPressGestureRecognizer *)longTap
{
    if(longTap.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(chartContentViewLongPress:content:)]){
        
        [self.delegate chartContentViewLongPress:self content:self.contentLabel.text];
    }
}
-(void)tapPress:(UILongPressGestureRecognizer *)tapPress
{
    if([self.delegate respondsToSelector:@selector(chartContentViewTapPress:content:)]){
    
        [self.delegate chartContentViewTapPress:self content:self.contentLabel.text];
    }
}
@end
