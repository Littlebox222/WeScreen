//
//  KeyBordVIew.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "KeyBordVIew.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "UIImage+StrethImage.h"

@interface KeyBordVIew()<UITextViewDelegate> {
    float _aa;
}
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UIButton *imageBtn;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *speakBtn;
@property (nonatomic) CGSize currentContentSize;
@property (nonatomic) CGRect origionFrameBack;
@property (nonatomic) CGRect origionFrameText;
@end

@implementation KeyBordVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialData];
        
        _aa = 33;
    }
    return self;
}

-(UIButton *)buttonWith:(NSString *)noraml hightLight:(NSString *)hightLight action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:noraml] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)initialData
{
    //工具条
    self.backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
    self.backImageView.image=[UIImage strethImageWith:@"toolbar_bottom_bar.png"];
    UIImage *img = nil;
    CGRect rect = CGRectMake(0, 0, self.backImageView.image.size.width, self.backImageView.image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1].CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backImageView.image = img;
    [self addSubview:self.backImageView];
    
    //麦克风
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceBtn setFrame:CGRectMake(0, 0, self.frame.size.height+5, self.frame.size.height)];
    [self.voiceBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
    [self.voiceBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 10, 8, 10)];
//    [self.voiceBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.voiceBtn addTarget:self action:@selector(swipeCancel:) forControlEvents:UIControlEventTouchDragExit];
    [self.voiceBtn addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
//    longPress.minimumPressDuration = 1.5;
    [self.voiceBtn addGestureRecognizer:longPress];
    
    [self addSubview:self.voiceBtn];
    
    //输入框
    self.textField = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, 180, self.frame.size.height*0.8)];
    self.textField.center = CGPointMake(145, self.frame.size.height*0.5);
    self.textField.placeholder = @"按住麦克风，语音输入文字";
    self.textField.delegate = self;
    [self addSubview:self.textField];
    
    //表情
    self.imageBtn=[self buttonWith:@"chat_bottom_smile_nor.png" hightLight:@"chat_bottom_smile_nor.png" action:@selector(imageBtnPress:)];
    [self.imageBtn setFrame:CGRectMake(0, 0, 27, 27)];
    [self.imageBtn setCenter:CGPointMake(260, self.frame.size.height*0.5)];
    [self addSubview:self.imageBtn];
    
    //更多
    self.addBtn=[self buttonWith:@"chat_bottom_up_nor.png" hightLight:@"chat_bottom_up_nor.png" action:@selector(addBtnPress:)];
    [self.addBtn setFrame:CGRectMake(0, 0, 27, 27)];
    [self.addBtn setCenter:CGPointMake(295, self.frame.size.height*0.5)];
    [self addSubview:self.addBtn];
}

- (void)aaa {
    NSLog(@"upOutSide");
}

-(void)handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
    
    if (paramSender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"chchchchcch");
    }
    
    if (paramSender.state == UIGestureRecognizerStateBegan){
        NSLog(@"Long PressGesture");
        [self.delegate beginRecord];
    }else if (paramSender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long PressGesture End");
    }
}

-(void)touchDown:(UIButton *)voice
{
    //开始录音
    NSLog(@"down");
    return;
    
    if([self.delegate respondsToSelector:@selector(beginRecord)]){
        [self.delegate beginRecord];
    }
    NSLog(@"开始录音");
}

-(void)touchUp:(UIButton *)voice
{
    //开始录音
    NSLog(@"touch cancel");
    return;
    
    if([self.delegate respondsToSelector:@selector(finishRecord)]){
        [self.delegate finishRecord];
    }
    NSLog(@"结束录音");
}

-(void)swipeCancel:(UIButton *)voice
{
    NSLog(@"drag out");
    return;
    
    if([self.delegate respondsToSelector:@selector(cancelRecord)]){
        [self.delegate cancelRecord];
    }
    NSLog(@"结束录音");
}
-(void)imageBtnPress:(UIButton *)image
{
    
    
}
-(void)addBtnPress:(UIButton *)image
{
    
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledBegin:)]){
        [self.delegate KeyBordView:self textFiledBegin:textView];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if (range.location==0) {
            return NO;
        }
        
        if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledReturn:)]){
            
            [self.delegate KeyBordView:self textFiledReturn:textView];
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
//    NSLog(@"~~~~~%ld", [textView.text length]);
//    NSLog(@"-----%f", self.textField.contentSize.height);
//    NSLog(@"frame.size.width  : %f", self.textField.frame.size.width);
//    NSLog(@"contentSize.width : %f", self.textField.contentSize.width);
//    NSLog(@"contentOffSet.x : %f", self.textField.contentOffset.x);
//    NSLog(@"contentOffSet.y : %f", self.textField.contentOffset.y);
    
    /*
    if (_aa != self.textField.contentSize.height) {
        
        if (self.textField.contentSize.height < 70) {
            int value = 17;
            float heightToFit = self.textField.contentSize.height - _aa;
            heightToFit  = heightToFit > value ? value : heightToFit;
            heightToFit  = heightToFit <- value ? -value : heightToFit;
            self.bb = heightToFit;
            _aa = self.textField.contentSize.height;
            
            [UIView animateWithDuration:0.3f animations:^{
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - heightToFit, self.frame.size.width, self.frame.size.height + heightToFit);
                self.textField.frame = CGRectMake(self.textField.frame.origin.x, self.textField.frame.origin.y, self.textField.frame.size.width, self.textField.frame.size.height+heightToFit);
                self.backImageView.frame = self.bounds;
            }];
            
            [self.delegate updateView:self];
        }
        
        //[textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
        CGPoint bottomOffset = CGPointMake(0, self.textField.contentSize.height - self.textField.bounds.size.height);
        [textView setContentOffset:bottomOffset animated:YES];
    }
     */
}

@end
