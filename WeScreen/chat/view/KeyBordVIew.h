//
//  KeyBordVIew.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@class KeyBordVIew;

@protocol KeyBordVIewDelegate <NSObject>

-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextView *)textFiled;
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextView *)textFiled;
-(void)beginRecord;
-(void)cancelRecord;
-(void)finishRecord;
-(void)updateView:(KeyBordVIew *)keyboardView;
@end


typedef void (^ContentSizeBlock)(CGSize contentSize);

@interface KeyBordVIew : UIView
@property (nonatomic,assign) id<KeyBordVIewDelegate>delegate;
@property (nonatomic,strong) UIPlaceHolderTextView *textField;
@property (nonatomic) CGRect origionFrameSelf;
@property (nonatomic) float bb;

-(void)setContentSizeBlock:(ContentSizeBlock) block;

@end
