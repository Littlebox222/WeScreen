//
//  ChartCell.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChartCell;

@protocol ChartCellDelegate <NSObject>

- (void)chartCell:(ChartCell *)chartCell tapType:(NSString *)tapType;

@end

#import "ChartCellFrame.h"
#import "ASIHTTPRequest.h"

@interface ChartCell : UITableViewCell<ASIHTTPRequestDelegate>
@property (nonatomic,strong) ChartCellFrame *cellFrame;
@property (nonatomic,assign) id<ChartCellDelegate> delegate;
@end
