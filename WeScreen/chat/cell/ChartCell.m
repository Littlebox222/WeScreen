//
//  ChartCell.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCell.h"
#import "ChartContentView.h"
@interface ChartCell()<ChartContentViewDelegate>
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) ChartContentView *chartView;
@property (nonatomic,strong) ChartContentView *currentChartView;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic) NSInteger likeNum;
@property (nonatomic,strong) UIButton *likeButton;
@end

@implementation ChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.icon=[[UIImageView alloc]init];
        [self.contentView addSubview:self.icon];
        self.chartView =[[ChartContentView alloc]initWithFrame:CGRectZero];
        self.chartView.delegate=self;
        [self.contentView addSubview:self.chartView];
        
        self.userName = @"小逗Baaa";
        self.userNameLabel = [[UILabel alloc] init];
        self.userNameLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.userNameLabel];
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *likeImage = [UIImage imageNamed:@"like.png"];
        [self.likeButton setImage:likeImage forState:UIControlStateNormal];
        [self.likeButton setBackgroundColor:[UIColor clearColor]];
        [self.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [self.likeButton setTitle:@"1015" forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.likeButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        
        [self.contentView addSubview:self.likeButton];
    }
    return self;
}
-(void)setCellFrame:(ChartCellFrame *)cellFrame
{
   
    _cellFrame=cellFrame;
    
    ChartMessage *chartMessage=cellFrame.chartMessage;
    
    self.icon.frame=cellFrame.iconRect;
    self.icon.image=[UIImage imageNamed:chartMessage.icon];
    
    self.userNameLabel.frame = cellFrame.nameRect;
    self.userNameLabel.text = self.userName;
   
    self.chartView.chartMessage=chartMessage;
    self.chartView.frame=cellFrame.chartViewRect;
    [self setBackGroundImageViewImage:self.chartView from:@"chatfrom_bg_normal@2x.png" to:@"chatto_bg_normal@2x.png"];
    self.chartView.contentLabel.text=chartMessage.content;
    
    if (cellFrame.chartMessage.messageType == kMessageFrom) {
        self.likeButton.frame = cellFrame.likeRect;
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(7, -20, 0, 0)];
        [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 33)];
        
        [self.likeButton setAlpha:1];
        [self.userNameLabel setAlpha:1];
    }else {
        self.likeButton.frame = CGRectZero;
        [self.userNameLabel setAlpha:0];
        [self.likeButton setAlpha:0];
    }
}
-(void)setBackGroundImageViewImage:(ChartContentView *)chartView from:(NSString *)from to:(NSString *)to
{
    UIImage *normal=nil ;
    if(chartView.chartMessage.messageType==kMessageFrom){
        
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.75];
//        UIEdgeInsets insets = UIEdgeInsetsMake(54, 21, 11, 12);
//        [normal resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        //NSLog(@"(%.0f, %.0f", normal.size.width * 0.2, normal.size.height * 0.9);
        
    }else if(chartView.chartMessage.messageType==kMessageTo){
        
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.75];
    }
    chartView.backImageView.image=normal;
}
-(void)chartContentViewLongPress:(ChartContentView *)chartView content:(NSString *)content
{
    [self becomeFirstResponder];
    UIMenuController *menu=[UIMenuController sharedMenuController];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
    self.contentStr=content;
    self.currentChartView=chartView;
}
-(void)chartContentViewTapPress:(ChartContentView *)chartView content:(NSString *)content
{
    if([self.delegate respondsToSelector:@selector(chartCell:tapContent:)]){
    
    
        [self.delegate chartCell:self tapContent:content];
    }
}
-(void)menuShow:(UIMenuController *)menu
{
    //[self setBackGroundImageViewImage:self.currentChartView from:@"chatfrom_bg_focused.png" to:@"chatto_bg_focused.png"];
}
-(void)menuHide:(UIMenuController *)menu
{
    //[self setBackGroundImageViewImage:self.currentChartView from:@"chatfrom_bg_normal.png" to:@"chatto_bg_normal.png"];
    self.currentChartView=nil;
    [self resignFirstResponder];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action ==@selector(copy:)){

        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard]setString:self.contentStr];
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)like:(id)sender {
    UIImage *likeImage = [UIImage imageNamed:@"like_highlighted.png"];
    [self.likeButton setImage:likeImage forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

@end
