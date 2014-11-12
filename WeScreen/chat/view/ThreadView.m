//
//  ThreadView.m
//  WeScreen
//
//  Created by hanchao on 14-10-27.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import "ThreadView.h"

#import "ThreadViewCellTableViewCell.h"

@implementation ThreadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc
{
    self.tableView = nil;
    
    [super dealloc];
}

-(void)setDataArray:(NSArray *)dataArray
{
    [_dataArray release];
    _dataArray = nil;
    _dataArray = [dataArray retain];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThreadViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ThreadViewCellTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.chartMessage = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartMessage *chartMessage = [self.dataArray objectAtIndex:indexPath.row];
    
    CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, MAXFLOAT)] autorelease];
    
    label.text = chartMessage.content;
    UIFont *font = [UIFont systemFontOfSize:16];
    CGRect labelRect = [label.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return labelRect.size.height + 75;
}

@end
