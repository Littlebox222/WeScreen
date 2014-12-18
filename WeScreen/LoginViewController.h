//
//  LoginViewController.h
//  WeScreen
//
//  Created by Littlebox on 12/16/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSArray *userArray;
@property (retain, nonatomic) NSDictionary *userDict;

@end
