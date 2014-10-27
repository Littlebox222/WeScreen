//
//  ThreadView.h
//  WeScreen
//
//  Created by hanchao on 14-10-27.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *dataArray;

@property (nonatomic, retain) IBOutlet UIButton *cancelBtn;

@end
