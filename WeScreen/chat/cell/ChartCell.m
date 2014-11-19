//
//  ChartCell.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCell.h"
#import "ChartContentView.h"
#import "AppDelegate.h"
#import "CardView.h"

@interface ChartCell()<ChartContentViewDelegate>
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) ChartContentView *chartView;
@property (nonatomic,strong) ChartContentView *currentChartView;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic) NSInteger likeNum;
@property (nonatomic,strong) UIButton *likeButton;

@property (nonatomic,strong) CardView *cardView;

@end

@implementation ChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)setCellFrame:(ChartCellFrame *)cellFrame
{
   
    _cellFrame = cellFrame;
    
    
    if (cellFrame.chartMessage.messageType == kMessageCardVote || cellFrame.chartMessage.messageType == kMessageCardShop) {
        
        [self.icon setHidden:YES];
        [self.userNameLabel setHidden:YES];
        [self.likeButton setHidden:YES];
        [self.chartView setHidden:YES];
        [self.cardView setHidden:NO];

        if (self.cardView == nil) {
            
            NSString *type = kCardTypeVote;
            if (cellFrame.chartMessage.messageType == kMessageCardShop) {
                type = kCardTypeShop;
            }
            
            self.cardView = [[CardView alloc] initWithFrame:cellFrame.chartViewRect type:type];
            [self.contentView addSubview:self.cardView];
        }else {
            self.cardView.frame = cellFrame.chartViewRect;
            //NSLog(@"%@", NSStringFromCGRect(self.cardView.frame));
        }
        
    }else {
        
        [self.cardView setHidden:YES];
        [self.icon setHidden:NO];
        [self.userNameLabel setHidden:NO];
        [self.likeButton setHidden:NO];
        [self.chartView setHidden:NO];
        
        ChartMessage *chartMessage = cellFrame.chartMessage;
        
        if (self.icon == nil) {
            self.icon = [[UIImageView alloc] init];
            self.icon.frame = cellFrame.iconRect;
            self.icon.image = [UIImage imageNamed:chartMessage.userInfo.iconUrl];
            [self.contentView addSubview:self.icon];
        }else {
            self.icon.frame = cellFrame.iconRect;
            self.icon.image = [UIImage imageNamed:chartMessage.userInfo.iconUrl];
        }
        
        
        if (self.userNameLabel == nil) {
            self.userNameLabel = [[UILabel alloc] init];
            self.userNameLabel.font = [UIFont systemFontOfSize:10];
            self.userNameLabel.frame = cellFrame.nameRect;
            self.userNameLabel.text = chartMessage.userInfo.name;
            [self.contentView addSubview:self.userNameLabel];
        }else {
            self.userNameLabel.frame = cellFrame.nameRect;
            self.userNameLabel.text = chartMessage.userInfo.name;
        }
        
        
        if (self.chartView == nil) {
            self.chartView = [[ChartContentView alloc] initWithFrame:CGRectZero];
            self.chartView.chartMessage = chartMessage;
            self.chartView.frame = cellFrame.chartViewRect;
            [self setBackGroundImageViewImage:self.chartView from:@"chatfrom_bg_normal@2x.png" to:@"chatto_bg_normal@2x.png"];
            self.chartView.contentLabel.text = chartMessage.content;
            self.chartView.delegate = self;
            [self.contentView addSubview:self.chartView];
        }else {
            self.chartView.chartMessage = chartMessage;
            self.chartView.frame = cellFrame.chartViewRect;
            [self setBackGroundImageViewImage:self.chartView from:@"chatfrom_bg_normal@2x.png" to:@"chatto_bg_normal@2x.png"];
            self.chartView.contentLabel.text = chartMessage.content;
        }
        
        
        
        if (cellFrame.chartMessage.messageType == kMessageFrom) {
            
            
            if (self.likeButton == nil) {
                self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *likeImage = [UIImage imageNamed:@"like.png"];
                [self.likeButton setImage:likeImage forState:UIControlStateNormal];
                [self.likeButton setBackgroundColor:[UIColor clearColor]];
                [self.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
                [self.likeButton setTitle:@"" forState:UIControlStateNormal];
                [self.likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.likeButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
                [self.contentView addSubview:self.likeButton];
                
                self.likeButton.frame = cellFrame.likeRect;
                [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(7, -20, 0, 0)];
                [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 33)];
                
                if (chartMessage.likeNum != 0) {
                    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld", chartMessage.likeNum] forState:UIControlStateNormal];
                }
                [self.likeButton setAlpha:1];
            }else {
                
                self.likeButton.frame = cellFrame.likeRect;
                [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(7, -20, 0, 0)];
                [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 33)];
                if (chartMessage.likeNum != 0) {
                    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld", chartMessage.likeNum] forState:UIControlStateNormal];
                }
                
                [self.likeButton setAlpha:1];
                
                if (![self.likeButton isUserInteractionEnabled]) {
                    UIImage *likeImage = [UIImage imageNamed:@"like_highlighted.png"];
                    [self.likeButton setImage:likeImage forState:UIControlStateNormal];
                }
            }
            [self.userNameLabel setAlpha:1];
            
        }else {
            
            if (self.likeButton == nil) {
                
                self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *likeImage = [UIImage imageNamed:@"like.png"];
                [self.likeButton setImage:likeImage forState:UIControlStateNormal];
                [self.likeButton setBackgroundColor:[UIColor clearColor]];
                [self.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
                [self.likeButton setTitle:[NSString stringWithFormat:@"%ld", [chartMessage likeNum]] forState:UIControlStateNormal];
                [self.likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.likeButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
                [self.contentView addSubview:self.likeButton];
                
                self.likeButton.frame = CGRectZero;
                [self.likeButton setAlpha:0];
                
            }else {
                
                self.likeButton.frame = CGRectZero;
                [self.likeButton setAlpha:0];
            }
            [self.userNameLabel setAlpha:0];
        }
    }
}
-(void)setBackGroundImageViewImage:(ChartContentView *)chartView from:(NSString *)from to:(NSString *)to
{
    UIImage *normal=nil ;
    if(chartView.chartMessage.messageType==kMessageFrom){
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.75];
    }else if(chartView.chartMessage.messageType==kMessageTo){
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.75];
    }
    chartView.backImageView.image = normal;
}
-(void)chartContentViewLongPress:(ChartContentView *)chartView content:(NSString *)content
{
    [self becomeFirstResponder];
    UIMenuController *menu=[UIMenuController sharedMenuController];
    if (self.cellFrame.chartMessage.messageType == kMessageFrom){
        //自定义UIMenuItem，@Ta、复制、回复、查看对话、举报
        UIMenuItem *itemAt = [[UIMenuItem alloc] initWithTitle:@"@Ta" action:@selector(atTaAction:)];
        UIMenuItem *itemCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
        UIMenuItem *itemBack = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(backAction:)];
        UIMenuItem *itemViewThread = [[UIMenuItem alloc] initWithTitle:@"查看对话" action:@selector(viewThreadAction:)];
        UIMenuItem *itemJubao = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(jubaoAction:)];
        menu.menuItems = [NSArray arrayWithObjects:itemAt,itemCopy,itemBack,itemViewThread,itemJubao, nil];
    }else{
        //自定义UIMenuItem，@Ta、复制、回复、查看对话、举报
        UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteAction:)];
        menu.menuItems = [NSArray arrayWithObjects:itemDelete, nil];
    }
    
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
    self.contentStr = content;
    self.currentChartView = chartView;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(atTaAction:) ||
        action == @selector(copyAction:) ||
        action == @selector(backAction:) ||
        action == @selector(viewThreadAction:) ||
        action == @selector(deleteAction:) ||
        action == @selector(jubaoAction:)
        )
    {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)atTaAction:(id)sender{
    [self.delegate chartCell:self tapType:@"atTa"];
}

-(void)copyAction:(id)sender{
    [self.delegate chartCell:self tapType:@"copy"];
}
-(void)backAction:(id)sender{
    [self.delegate chartCell:self tapType:@"back"];
}
-(void)viewThreadAction:(id)sender{
    [self.delegate chartCell:self tapType:@"viewThread"];
}
-(void)jubaoAction:(id)sender{
    [self.delegate chartCell:self tapType:@"jubao"];
}
-(void)deleteAction:(id)sender{
    [self.delegate chartCell:self tapType:@"delete"];
}

//-(void)chartContentViewTapPress:(ChartContentView *)chartView content:(NSString *)content
//{
//    if([self.delegate respondsToSelector:@selector(chartCell:tapContent:)]){
//    
//    
//        [self.delegate chartCell:self tapContent:content];
//    }
//}
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)like:(id)sender {
    
    NSString *string = [NSString stringWithFormat:@"http://10.75.2.56:8080/comments/like?uid=%@&cid=%@", kCurrentUserID, self.chartView.chartMessage.mid];
    NSURL *url = [NSURL URLWithString:string];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.delegate = self;
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error:nil];
    
    if ([[json objectForKey:@"count"] integerValue] != -1) {
        
        UIImage *likeImage = [UIImage imageNamed:@"like_highlighted.png"];
        [self.likeButton setImage:likeImage forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.likeButton setTitle:[[json objectForKey:@"count"] stringValue] forState:UIControlStateNormal];
        [self.likeButton setUserInteractionEnabled:NO];
        
        _cellFrame.chartMessage.likeNum = [[json objectForKey:@"count"] integerValue];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    NSLog(@"%@", error);
}

@end
