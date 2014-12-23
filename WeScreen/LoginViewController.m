//
//  LoginViewController.m
//  WeScreen
//
//  Created by Littlebox on 12/16/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RootViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize tableView = _tableView;
@synthesize userArray = _userArray;
@synthesize userDict = _userDict;

- (void)dealloc {
    
    [_userArray release];
    [_userDict release];
    
    [_tableView setDelegate:nil];
    [_tableView release];
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.userArray = [[NSArray alloc] initWithObjects:
                          @"陈翔家的小天",
                          @"Catherine_Ren",
                          @"菁菁无悔",
                          @"fudanchen",
                          @"雪之夏沫",
                          @"xiaochuan",
                          @"shenyong",
                          @"kaixin",
                          @"feifan",
                          @"wangxin",
                          @"笨笨跳跳小白兔",
                          @"方块小鱼",
                          @"箐公子",
                          @"sophia王亚",
                          @"Yes_MyLady_",
                          @"龍妹妹mua",nil];
        
        self.userDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"3788782974795784", @"kUser1",
                         @"3788785373937674", @"kUser2",
                         @"3788788305756176", @"kUser3",
                         @"3788788511277073", @"kUser4",
                         @"3788788708409362", @"kUser5",
                         @"3775796348452870", @"kUser6",
                         @"3775796952432647", @"kUser7",
                         @"3775797149564936", @"kUser8",
                         @"3775797241839625", @"kUser9",
                         @"3775805919854603", @"kUser10",
                         @"3789159241613359", @"kUser11",
                         @"3789159384219696", @"kUser12",
                         @"3789159497465905", @"kUser13",
                         @"3789159602323506", @"kUser14",
                         @"3789159719764019", @"kUser15",
                         @"3789161703669813", @"kUser16", nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"选择用户登录";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain] autorelease];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
    }
    cell.textLabel.text = [self.userArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *user = [NSString stringWithFormat:@"kUser%lu", indexPath.row+1];
    kCurrentUserID = [self.userDict objectForKey:user];
    RootViewController *rootViewController = [[[RootViewController alloc] init] autorelease];
    [self.navigationController pushViewController:rootViewController animated:YES];
}

@end
