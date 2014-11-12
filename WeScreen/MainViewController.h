//
//  MainViewController.h
//  WeScreen
//
//  Created by Littlebox on 14-10-3.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate>

@property (nonatomic, retain) NSString *topic;

@end
