//
//  CardView.m
//  WeScreen
//
//  Created by Littlebox on 11/17/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import "CardView.h"
#import "CardViewCell.h"
#import "CardViewCellShop.h"

NSString *kCardTypeVote = @"cardVote";
NSString *kCardTypeShop = @"cardShop";

@implementation CardView

@synthesize cardType = _cardType;

- (void)dealloc {
    
    [_cardType release];
    [_tableView release];
    [_adView release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame type:(NSString *)type {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] autorelease];
        [self.tableView setScrollEnabled:NO];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self addSubview:_tableView];
        
        
        
        self.adView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 136)] autorelease];
        [self addSubview:_adView];
        
        
        
        if ([type isEqualToString:kCardTypeVote]) {
            
            self.cardType = kCardTypeVote;
            self.tableView.frame = CGRectMake(0, 136, 300, 300);
            self.adView.image = [UIImage imageNamed:@"vote_header.png"];
            
        }else if ([type isEqualToString:kCardTypeShop]) {
            self.cardType = kCardTypeShop;
            self.tableView.frame = CGRectMake(0, 136, 300, 120);
            self.adView.image = [UIImage imageNamed:@"shop_header.png"];
        }
        
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (self.tableView) {
        
        if (self.cardType == kCardTypeVote) {
            self.tableView.frame = CGRectMake(0, 136, 300, 300);
        }else if (self.cardType == kCardTypeShop) {
            self.tableView.frame = CGRectMake(0, 136, 300, 120);
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cardType isEqualToString:kCardTypeVote] ? 5 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cardType isEqualToString:kCardTypeVote]) {
        
        CardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CardViewCell" owner:self options:nil] objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell setSupportButtonPressedBlock:^(id sender) {

                NSArray *cells = [tableView visibleCells];
                
                for (CardViewCell *c in cells) {
                    
                    if (![c isEqual:cell]) {
                        [c.supportButton setEnabled:NO];
                        [c.supportButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    }else {
                        [c.supportButton setEnabled:NO];
                        [c.supportButton setTitle:@"已支持" forState:UIControlStateNormal];
                    }
                }
                
//                NSString *string = [NSString stringWithFormat:@"http://10.75.2.56:8080/card/create"];
//                NSURL *url = [NSURL URLWithString:string];
//                ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
//                [request setPostValue:@"Where" forKey:@"card"];
//                [request setPostValue:@"0,1,2,3,4" forKey:@"items"];
//                request.delegate = self;
//                request.defaultResponseEncoding = NSUTF8StringEncoding;
//                [request startAsynchronous];
                
                NSString *string = [NSString stringWithFormat:@"http://10.75.2.56:8080/card/vote"];
                NSURL *url = [NSURL URLWithString:string];
                ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
                [request setPostValue:@"Where" forKey:@"card"];
                [request setPostValue:[NSString stringWithFormat:@"%ld", indexPath.row] forKey:@"item"];
                request.delegate = self;
                request.defaultResponseEncoding = NSUTF8StringEncoding;
                [request startAsynchronous];


            }];
        }
        
        if (indexPath.row == 0) {
            cell.avaterImageView.image = [UIImage imageNamed:@"support_1.png"];
            cell.nameLabel.text = @"Joe";
            cell.detailLabel.text = @"曹格儿子曹三丰";
        }else if (indexPath.row == 1) {
            cell.avaterImageView.image = [UIImage imageNamed:@"support_2.png"];
            cell.nameLabel.text = @"杨阳洋";
            cell.detailLabel.text = @"杨威儿子";
        }else if (indexPath.row == 2) {
            cell.avaterImageView.image = [UIImage imageNamed:@"support_3.png"];
            cell.nameLabel.text = @"贝儿";
            cell.detailLabel.text = @"陆毅的女儿";
        }else if (indexPath.row == 3) {
            cell.avaterImageView.image = [UIImage imageNamed:@"support_4.png"];
            cell.nameLabel.text = @"Feynman";
            cell.detailLabel.text = @"吴镇宇儿子";
        }else if (indexPath.row == 4) {
            cell.avaterImageView.image = [UIImage imageNamed:@"support_5.jpg"];
            cell.nameLabel.text = @"多多";
            cell.detailLabel.text = @"黄磊的女儿";
        }
        
        return cell;
        
    }else {
        
        CardViewCellShop *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CardViewCellShop" owner:self options:nil] objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell setShopButtonPressedBlock:^(id sender) {
                NSString *message = [NSString stringWithFormat:@"\n%@\n\n已添加到购物车", cell.nameLabel.text];
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"知道了！" otherButtonTitles: nil];
                [alter show];
            }];
        }
        
        if (indexPath.row == 0) {
            
            cell.avaterImageView.image = [UIImage imageNamed:@"shop_1.png"];
            cell.nameLabel.text = @"爸爸去哪儿2第二季黄磊同款彩色民族T恤";
            cell.detailLabel.text = @"原价￥120.0      销量：23545";
            cell.priceLabel.text = @"￥98.00";
            
        }else if (indexPath.row == 1) {
            
            cell.avaterImageView.image = [UIImage imageNamed:@"shop_2.png"];
            cell.nameLabel.text = @"爸爸去哪儿2第二季黄磊女儿多多同款压发圈蝴蝶结发簪";
            cell.detailLabel.text = @"原价￥20.0        销量：23545";
            cell.priceLabel.text = @"￥9.80";
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error:nil];
    
    NSLog(@"%@", responseString);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
}

@end
