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
@property (strong, nonatomic) ContentSizeBlock sizeBlock;
@end

@implementation KeyBordVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialData];
        [self addConstraint];
        _aa = 33;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyPressed:) name: UITextViewTextDidChangeNotification object: nil];
        self.textField.scrollEnabled = NO;
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
    
    //麦克风
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceBtn setFrame:CGRectZero];
    [self.voiceBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
    [self.voiceBtn addTarget:self action:@selector(voiceBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    longPress.minimumPressDuration = 0.2;
    [self.voiceBtn addGestureRecognizer:longPress];
    [self addSubview:self.voiceBtn];
    
    //输入框
    self.textField = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectZero];
    self.textField.placeholder = @"按住麦克风，语音输入文字";
    self.textField.delegate = self;
//    self.textField
    [self addSubview:self.textField];
    
    //表情
    self.imageBtn=[self buttonWith:@"chat_bottom_smile_nor.png" hightLight:@"chat_bottom_smile_nor.png" action:@selector(imageBtnPress:)];
    [self.imageBtn setFrame:CGRectZero];
    [self addSubview:self.imageBtn];
    
    //更多
    self.addBtn=[self buttonWith:@"chat_bottom_up_nor.png" hightLight:@"chat_bottom_up_nor.png" action:@selector(addBtnPress:)];
    [self.addBtn setFrame:CGRectZero];
    [self addSubview:self.addBtn];
}


- (void)addConstraint
{
    //给voicebutton添加约束
    self.voiceBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *voiceConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_voiceBtn(27)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_voiceBtn)];
    [self addConstraints:voiceConstraintH];
    NSArray *voiceConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_voiceBtn(27)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_voiceBtn)];
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
}

- (void)voiceBtnTapped {
    
    NSLog(@"voice button tapped");
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按住语音输入" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alter show];
}

-(void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender{
    
    static int i = 1;
    static double iTime = 0;
    if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]) {
        
        UILongPressGestureRecognizer * longPress = sender;
        
        //录音开始
        if (longPress.state == UIGestureRecognizerStateBegan) {
            
            i = 1;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginRecord)]) {
                
                iTime = [[NSDate date] timeIntervalSince1970];
                [self.delegate beginRecord];
            }
            
            //TODO:界面切换
        }
        
        
        //取消录音
        if (longPress.state == UIGestureRecognizerStateChanged) {
            
            CGPoint piont = [longPress locationInView:self];
            NSLog(@"%f",piont.x);
            
            if (piont.x > 40) {
                
                if (i == 1) {
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRecord)]) {
                        [self.delegate cancelRecord];
                    }
                    
                    //TODO:界面切换
                    i = 0;
                }
            }
        }
        
        if (longPress.state == UIGestureRecognizerStateEnded) {
            
            if (i == 1) {
                
                NSLog(@"录音结束");
                
                //TODO:界面切换
                double cTime = [[NSDate date] timeIntervalSince1970];
                
                if (cTime - iTime > 1) {
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(finishRecord)]) {
                        [self.delegate finishRecord];
                    }
                    
                }else {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRecord)]) {
                        [self.delegate cancelRecord];
                    }
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"录音时间太短！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
                    [alter show];
                }
            }
        }
    }
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
            
            NSString *tmp = @"测试";
            CGFloat tmpHeight = [tmp sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999) lineBreakMode:UILineBreakModeWordWrap].height;
            
            
            CGSize newSize = [self.textField.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999) lineBreakMode:UILineBreakModeWordWrap];
            NSInteger lineNum = newSize.height / tmpHeight;
            NSInteger newSizeH = newSize.height;
            NSInteger newSizeW = newSize.width;
            
            
            CGSize contentSize = CGSizeMake(self.textField.frame.size.width-5, 44);
            if (lineNum > 1) {
                contentSize.height = lineNum*tmpHeight+44-tmpHeight;
            }
            
            self.sizeBlock(contentSize);
            
            [self.textField setScrollEnabled:YES];
            [self.textField scrollRectToVisible:CGRectMake(0, 0, 1, contentSize.height+16) animated:NO];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{

}

-(void)setContentSizeBlock:(ContentSizeBlock)block
{
    self.sizeBlock = block;
}


-(void) keyPressed: (NSNotification*) notification{
    // get the size of the text block so we can work our magic
    NSString *tmp = @"测试";
    CGFloat tmpHeight = [tmp sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    
    CGSize newSize = [self.textField.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.textField.frame.size.width-5,9999) lineBreakMode:UILineBreakModeWordWrap];
    NSInteger lineNum = newSize.height / tmpHeight;
    NSInteger newSizeH = newSize.height;
    NSInteger newSizeW = newSize.width;
//    NSLog(@"NEW SIZE : %ld X %ld", newSizeW, newSizeH);
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

@end
