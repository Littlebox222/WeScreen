//
//  ChartCellFrame.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kIconMarginX 5
#define kIconMarginY 5

#import "ChartCellFrame.h"

@implementation ChartCellFrame

-(void)setChartMessage:(ChartMessage *)chartMessage
{
    _chartMessage = chartMessage;
    
    if (chartMessage.messageType == kMessageCardVote) {
        
        CGSize winSize = [UIScreen mainScreen].bounds.size;
//        self.chartViewRect = CGRectMake(winSize.width/2 - 150, 20, 300, 436);
        self.chartViewRect = CGRectMake(winSize.width/2 - 150, 20, 300, 256);
        
    }else if (chartMessage.messageType == kMessageCardShop) {
        
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        self.chartViewRect = CGRectMake(winSize.width/2 - 150, 20, 300, 256);
        
    }else {
        
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        winSize.width -= 20;
        CGFloat iconX = kIconMarginX;
        CGFloat iconY = kIconMarginY;
        CGFloat iconWidth = 40;
        CGFloat iconHeight = 40;
        
        CGFloat nameX = iconX + iconWidth + 5;
        CGFloat nameY = iconY-5;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 25;
        
        CGFloat likeX = winSize.width - 80;
        CGFloat likeY = iconY-25;
        CGFloat likeWidth = 80;
        CGFloat likeHeight = 60;
        
        if(chartMessage.messageType == kMessageFrom){
            
            self.iconRect = CGRectMake(iconX, iconY, iconWidth, iconHeight);
            self.nameRect = CGRectMake(nameX, nameY, nameWidth, nameHeight);
            self.likeRect = CGRectMake(likeX, likeY, likeWidth, likeHeight);
            
            CGFloat contentX = CGRectGetMaxX(self.iconRect)+kIconMarginX;
            CGFloat contentY = iconY-5;
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
            CGSize contentSize=[chartMessage.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
            
            self.chartViewRect = CGRectMake(contentX, contentY+25, contentSize.width+20, contentSize.height+26);
            
        }else if (chartMessage.messageType == kMessageTo){
            
            iconX = winSize.width - kIconMarginX - iconWidth;
            self.iconRect = CGRectMake(iconX, iconY, iconWidth, iconHeight);
            
            CGFloat contentY = iconY;
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
            CGSize contentSize = [chartMessage.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
            
            CGFloat contentX = iconX - contentSize.width - iconWidth;
            
            self.chartViewRect = CGRectMake(contentX+15, contentY, contentSize.width+20, contentSize.height+26);
        }
        
    }
    
    
    
    self.cellHeight = MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.chartViewRect)) + kIconMarginX;
}
@end
