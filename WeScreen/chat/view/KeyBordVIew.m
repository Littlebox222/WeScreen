//
//  KeyBordVIew.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "KeyBordVIew.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "UIImage+StrethImage.h"

@interface KeyBordVIew()<UITextViewDelegate> {
}
@property (nonatomic,strong) UIImageView *voiceBtn;
@property (nonatomic,strong) UIButton *imageBtn;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *speakBtn;
@property (nonatomic,strong) UITextView *tipView;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) ContentSizeBlock sizeBlock;
@property (nonatomic,strong) NSTimer *updateTimer;
@property (nonatomic,assign) int recordedTime;
@end

@implementation KeyBordVIew

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
    if (self.updateTimer != nil) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    
    self.voiceBtn = nil;
    self.imageBtn = nil;
    self.addBtn = nil;
    self.speakBtn = nil;
    self.tipView = nil;
    self.sendBtn = nil;
    self.sizeBlock = nil;

    self.textField.delegate = nil;
    self.textField = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialData];
        [self addConstraint];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyPressed:) name: UITextViewTextDidChangeNotification object: nil];
        self.textField.scrollEnabled = NO;
        
        self.recordedTime = 0;
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
    [self setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]];
    
    //输入框
    self.textField = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectZero];
    self.textField.placeholder = @"按住麦克风，语音输入文字";
    self.textField.delegate = self;
    [self addSubview:self.textField];
    
    //麦克风
    UIImage *image = [UIImage imageNamed:@"chat_bottom_voice_nor.png"];
    image = [UIImage imageWithCGImage:[image CGImage] scale:1.7 orientation:UIImageOrientationUp];
    self.voiceBtn = [[UIImageView alloc] initWithImage:image];
    [self.voiceBtn setContentMode:UIViewContentModeCenter];
    [self.voiceBtn setUserInteractionEnabled:YES];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    longPress.minimumPressDuration = 0.1;
    [self.voiceBtn addGestureRecognizer:longPress];
    [self addSubview:self.voiceBtn];
    
    //表情
    self.imageBtn=[self buttonWith:@"chat_bottom_smile_nor.png" hightLight:@"chat_bottom_smile_nor.png" action:@selector(imageBtnPress:)];
    [self.imageBtn setFrame:CGRectZero];
    [self addSubview:self.imageBtn];
    
    //更多
    self.addBtn=[self buttonWith:@"chat_bottom_up_nor.png" hightLight:@"chat_bottom_up_nor.png" action:@selector(addBtnPress:)];
    [self.addBtn setFrame:CGRectZero];
    [self addSubview:self.addBtn];
    
    //提示
    self.tipView = [[UITextView alloc] initWithFrame:CGRectZero];
    [self.tipView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]];
    [self.tipView setHidden:YES];
    [self.tipView setTextAlignment:NSTextAlignmentCenter];
    [self.tipView setText:[NSString stringWithFormat:@"向右滑动取消              %ds", self.recordedTime]];
    [self.tipView setFont:[UIFont systemFontOfSize:18]];
    [self.tipView setTextColor:[UIColor grayColor]];
    [self addSubview:self.tipView];
    
    //发送按钮
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTintColor:[UIColor colorWithRed:228.0/255 green:79.0/255 blue:14.0/255 alpha:1]];
    [self.sendBtn addTarget:self action:@selector(sendBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBtn setHidden:YES];
    [self addSubview:self.sendBtn];
}


- (void)addConstraint
{
    //给voicebutton添加约束
    self.voiceBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *voiceConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-15)-[_voiceBtn(80)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_voiceBtn)];
    [self addConstraints:voiceConstraintH];
    NSArray *voiceConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-15)-[_voiceBtn(70)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_voiceBtn)];
    [self addConstraints:voiceConstraintV];

    //给MoreButton添加约束
    self.addBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *moreButtonH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_addBtn(27)]-8-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_addBtn)];
    [self addConstraints:moreButtonH];
    NSArray *moreButtonV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_addBtn(27)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_addBtn)];
    [self addConstraints:moreButtonV];

    //给imageButton添加约束
    self.imageBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *imageButtonH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageBtn(27)]-45-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_imageBtn)];
    [self addConstraints:imageButtonH];
    NSArray *imageButtonV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_imageBtn(27)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_imageBtn)];
    [self addConstraints:imageButtonV];
    
    //给文本框添加约束
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *sendTextViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-45-[_textField]-80-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_textField)];
    [self addConstraints:sendTextViewConstraintH];
    NSArray *sendTextViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_textField]-5-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_textField)];
    [self addConstraints:sendTextViewConstraintV];
    
    //给提示框加约束
    self.tipView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *sendTipViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-45-[_tipView]-45-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tipView)];
    [self addConstraints:sendTipViewConstraintH];
    NSArray *sendTipViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_tipView]-8-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tipView)];
    [self addConstraints:sendTipViewConstraintV];
    
    //给发送按钮加约束
    self.sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *sendButtonConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sendBtn(54)]-15-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendBtn)];
    [self addConstraints:sendButtonConstraintH];
    NSArray *sendButtonConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_sendBtn(27)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendBtn)];
    [self addConstraints:sendButtonConstraintV];
}

- (void)changeToolView:(NSInteger)state {
    
    if (state == 1) {
        
        [self.imageBtn setHidden:YES];
        [self.addBtn setHidden:YES];
        [self.textField setHidden:YES];
        [self.sendBtn setHidden:YES];
        [self.tipView setHidden:NO];
        [self.tipView setText:[NSString stringWithFormat:@"向右滑动取消              %ds", self.recordedTime]];
        
    }else if (state == 0) {
        
        if (self.textField.hasText) {
            [self.imageBtn setHidden:YES];
            [self.addBtn setHidden:YES];
            [self.sendBtn setHidden:NO];
        }else {
            self.isReturnBack = NO;
            [self.imageBtn setHidden:NO];
            [self.addBtn setHidden:NO];
            [self.sendBtn setHidden:YES];
        }
        
        [self.textField setHidden:NO];
        [self.tipView setHidden:YES];
        [self.tipView setText:[NSString stringWithFormat:@"向右滑动取消              %ds", self.recordedTime]];
    }
}

- (void)voiceBtnTapped {
    
    NSLog(@"voice button tapped");
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按住语音输入" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//    [alter show];
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender{
    

    static int i = 1;
    static double iTime = 0;
    if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]) {
        
        UILongPressGestureRecognizer * longPress = sender;

        //录音开始
        if (longPress.state == UIGestureRecognizerStateBegan) {

            i = 1;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginRecord)]) {
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                if (self.updateTimer != nil) {
                    [self.updateTimer invalidate];
                    self.updateTimer = nil;
                }
                self.recordedTime = 0;
                self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                    target:self
                                                                  selector:@selector(updateTipString)
                                                                  userInfo:nil
                                                                   repeats:YES];
                
                iTime = [[NSDate date] timeIntervalSince1970];
                [self.delegate beginRecord];
                
                //TODO:界面切换
                [self changeToolView:i];
            }
        }
        
        
        //取消录音
        if (longPress.state == UIGestureRecognizerStateChanged) {
            
            CGPoint piont = [longPress locationInView:self];
            NSLog(@"%f",piont.x);
            
            if (piont.x < -20) {
                
                if (i == 1) {
                    
                    if (self.updateTimer != nil) {
                        [self.updateTimer invalidate];
                        self.updateTimer = nil;
                        self.recordedTime = 0;
                    }
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRecord)]) {
                        [self.delegate cancelRecord];
                    }
                    
                    [self changeToolView:0];
                }
            }
        }
        
        if (longPress.state == UIGestureRecognizerStateEnded) {
            
            if (i == 1) {
                
                NSLog(@"录音结束");
                
                double cTime = [[NSDate date] timeIntervalSince1970];
                
                if (cTime - iTime > 1) {
                    
                    if (self.updateTimer != nil) {
                        [self.updateTimer invalidate];
                        self.updateTimer = nil;
                        self.recordedTime = 0;
                    }
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(finishRecord)]) {
                        [self.delegate finishRecord];
                    }
                    
                }else {
                    
                    if (self.updateTimer != nil) {
                        [self.updateTimer invalidate];
                        self.updateTimer = nil;
                        self.recordedTime = 0;
                    }
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRecord)]) {
                        [self.delegate cancelRecord];
                    }
                    [self changeToolView:0];
//                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"录音时间太短！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//                    [alter show];
                }
            }
        }
    }
}

- (void)imageBtnPress:(UIButton *)image
{
    
    
}

- (void)addBtnPress:(UIButton *)add
{
    
    
}

- (void)sendBtnPress:(UIButton *)send
{
    if (!self.textField.hasText) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(KeyBordView:textFiledReturn:)]) {
        
        [self.delegate KeyBordView:self textFiledReturn:self.textField];
        
        NSString *tmp = @"测试";
        CGFloat tmpHeight = [tmp sizeWithFont:[UIFont systemFontOfSize:14]
                            constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999)
                                lineBreakMode:UILineBreakModeWordWrap].height;
        
        
        CGSize newSize = [self.textField.text sizeWithFont:[UIFont systemFontOfSize:14]
                                         constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999)
                                             lineBreakMode:UILineBreakModeWordWrap];
        
        NSInteger lineNum = newSize.height / tmpHeight;
        CGSize contentSize = CGSizeMake(self.textField.frame.size.width-5, 44);
        if (lineNum > 1) {
            contentSize.height = lineNum*tmpHeight+44-tmpHeight;
        }
        
        self.sizeBlock(contentSize);
        [self.textField setScrollEnabled:YES];
        [self.textField scrollRectToVisible:CGRectMake(0, 0, 1, contentSize.height+16) animated:NO];
        
        [self changeToolView:0];
    }
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
        
        if (range.location == 0) {
            return NO;
        }
        
        if ([self.delegate respondsToSelector:@selector(KeyBordView:textFiledReturn:)]) {
            
            [self.delegate KeyBordView:self textFiledReturn:textView];
            
            NSString *tmp = @"测试";
            CGFloat tmpHeight = [tmp sizeWithFont:[UIFont systemFontOfSize:14]
                                constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999)
                                    lineBreakMode:UILineBreakModeWordWrap].height;
            
            
            CGSize newSize = [self.textField.text sizeWithFont:[UIFont systemFontOfSize:14]
                                             constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999)
                                                 lineBreakMode:UILineBreakModeWordWrap];
            
            NSInteger lineNum = newSize.height / tmpHeight;
            CGSize contentSize = CGSizeMake(self.textField.frame.size.width-5, 44);
            if (lineNum > 1) {
                contentSize.height = lineNum*tmpHeight+44-tmpHeight;
            }
            
            self.sizeBlock(contentSize);
            [self.textField setScrollEnabled:YES];
            [self.textField scrollRectToVisible:CGRectMake(0, 0, 1, contentSize.height+16) animated:NO];
            
            [self changeToolView:0];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)keyPressed:(NSNotification*)notification {
    
    [self changeToolView:0];

    NSString *tmp = @"测试";
    CGFloat tmpHeight = [tmp sizeWithFont:[UIFont systemFontOfSize:14]
                        constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999)
                            lineBreakMode:UILineBreakModeWordWrap].height;
    
    
    CGSize newSize = [self.textField.text sizeWithFont:[UIFont systemFontOfSize:14]
                                     constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999)
                                         lineBreakMode:UILineBreakModeWordWrap];
    
    NSInteger lineNum = newSize.height / tmpHeight;

    if (self.textField.hasText && newSize.height < 60) {
        CGSize contentSize = CGSizeMake(self.textField.frame.size.width-5, 44);
        if (lineNum > 1) {
            contentSize.height = lineNum*tmpHeight+44-tmpHeight;
        }

        self.sizeBlock(contentSize);
        
        [self.textField setScrollEnabled:YES];
        [self.textField scrollRectToVisible:CGRectMake(0, 0, 1, contentSize.height+16) animated:NO];
    }
}

- (void)setContentSizeBlock:(ContentSizeBlock)block
{
    self.sizeBlock = block;
}

- (void)updateTipString {
    self.recordedTime++;
    [self.tipView setText:[NSString stringWithFormat:@"向右滑动取消              %ds", self.recordedTime]];
}

@end
