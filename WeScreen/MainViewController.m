//
//  MainViewController.m
//  WeScreen
//
//  Created by Littlebox on 14-10-3.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import "MainViewController.h"

#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "ChartCell.h"
#import "KeyBordVIew.h"

#import "CardViewController.h"
#import "PopoverView.h"
#import "MenuView.h"

#import "WKVerticalScrollBar.h"
#import "WKAccessoryView.h"

#import <QuartzCore/QuartzCore.h>
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "ISRDataHelper.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyResourceUtil.h"
#import "RecognizerFactory.h"

#import "ThreadView.h"

@class IFlyDataUploader;
@class IFlySpeechRecognizer;

static NSString *const cellIdentifier=@"QQChart";

@interface MainViewController () <KeyBordVIewDelegate,ChartCellDelegate,PopoverViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KeyBordVIew *keyBordView;
@property (nonatomic,strong) NSMutableArray *cellFrames;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIButton *navMenuButton;
@property (nonatomic,strong) PopoverView *popoverView;
@property (nonatomic,strong) WKVerticalScrollBar *verticalScrollBar;
@property (nonatomic,strong) WKAccessoryView *accessoryView;

@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;
@property (nonatomic, strong) IFlyDataUploader     * uploader;
@property (nonatomic, strong) NSString             * iSRResult;

@property (nonatomic, strong) ThreadView *threadView;//查看对话view
@property (strong, nonatomic) NSLayoutConstraint *keyBordViewConstraintHeight;
@end

@implementation MainViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
    [_verticalScrollBar release];
    //[_accessoryView release];
    
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_tableView release];
    
    _keyBordView.delegate = nil;
    [_keyBordView release];
    
    self.uploader = nil;
    [_iSRResult release];
    
    [_cellFrames removeAllObjects];
    [_cellFrames release];

    [_fileName release];
    [_rightButton release];
    [_navMenuButton release];
    
    self.threadView = nil;
    
    [_keyBordViewConstraintHeight release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.view = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //取消识别
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate: nil];
    
    
    
    [super viewWillDisappear:animated];
}

#pragma mark - keyboard

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Basic use for the info panel

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    self.navMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navMenuButton setFrame:CGRectMake(0, 0, 100, 42)];
    UIImage *dropImage = [UIImage imageNamed:@"drop_button_down.png"];
    dropImage = [UIImage imageWithCGImage:[dropImage CGImage] scale:2 orientation:(dropImage.imageOrientation)];
    [self.navMenuButton setImage:dropImage forState:UIControlStateNormal];
    [self.navMenuButton setBackgroundColor:[UIColor clearColor]];
    [self.navMenuButton addTarget:self action:@selector(dropDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.navMenuButton setTitle:@"爸爸去哪儿9.7" forState:UIControlStateNormal];
    [self.navMenuButton setTitleColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1] forState:UIControlStateNormal];
    [self.navMenuButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.navMenuButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.navMenuButton setImageEdgeInsets:UIEdgeInsetsMake(2, 110, 0, -30)];
    self.navigationItem.titleView = self.navMenuButton;
    
    
    self.title=@"爸爸去哪儿9.7";
    self.view.backgroundColor=[UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1];
    
    
    //add UItableView
    self.tableView=[[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, self.view.frame.size.height-44) style:UITableViewStylePlain] autorelease];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor=[UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [self.tableView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    [self.view addSubview:self.tableView];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setFrame:CGRectMake(0, 0, 25, 25)];
    UIImage *rightButtonImage = [UIImage imageNamed:@"navigationbar_rightbutton.png"];
    [self.rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    [self.rightButton setBackgroundColor:[UIColor clearColor]];
    [self.rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.rightButton] autorelease];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    //
    self.keyBordView = [[[KeyBordVIew alloc]initWithFrame:CGRectZero] autorelease];
    self.keyBordView.delegate = self;
    [self.view addSubview:self.keyBordView];

    _keyBordView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *toolViewContraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_keyBordView]|"
                                                                          options:0
                                                                          metrics:0
                                                                            views:NSDictionaryOfVariableBindings(_keyBordView)];
    [self.view addConstraints:toolViewContraintH];
    NSArray * tooViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_keyBordView(44)]|"
                                                                           options:0
                                                                           metrics:0
                                                                             views:NSDictionaryOfVariableBindings(_keyBordView)];
    [self.view addConstraints:tooViewConstraintV];
    self.keyBordViewConstraintHeight = tooViewConstraintV[0];
    
    //
    self.verticalScrollBar = [[[WKVerticalScrollBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width-14, 85, 8, self.view.frame.size.height - 152)] autorelease];
    [_verticalScrollBar setScrollView:self.tableView];
    [self.view addSubview:_verticalScrollBar];
    
    _accessoryView = [[WKAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [_accessoryView setForegroundColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
    [_accessoryView setAlpha:0.0f];
    [_verticalScrollBar setHandleAccessoryView:_accessoryView];
    
    
    //初始化数据
    [self initwithData];
    
    //
    _iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
    self.uploader = [[[IFlyDataUploader alloc] init] autorelease];
    
    [self setKeyBordViewBlock];
}

-(void)initwithData
{
    
    self.cellFrames=[NSMutableArray array];
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
    NSArray *data=[NSArray arrayWithContentsOfFile:path];
    
    for(NSDictionary *dict in data){
        
        ChartCellFrame *cellFrame=[[[ChartCellFrame alloc]init] autorelease];
        ChartMessage *chartMessage=[[[ChartMessage alloc]init] autorelease];
        chartMessage.dict=dict;
        cellFrame.chartMessage=chartMessage;
        [self.cellFrames addObject:cellFrame];
        [self.cellFrames addObject:cellFrame];
    }
    
    for(NSDictionary *dict in data){
        
        ChartCellFrame *cellFrame=[[[ChartCellFrame alloc]init] autorelease];
        ChartMessage *chartMessage=[[[ChartMessage alloc]init] autorelease];
        chartMessage.dict=dict;
        cellFrame.chartMessage=chartMessage;
        [self.cellFrames addObject:cellFrame];
        [self.cellFrames addObject:cellFrame];
    }
    
}

- (void)selectRightAction:(id)sender
{
    CardViewController *cardViewController = [[[CardViewController alloc] init] autorelease];
    [self.navigationController pushViewController:cardViewController animated:NO];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellFrames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellFrames[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[ChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.delegate=self;
    }
    cell.cellFrame=self.cellFrames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)chartCell:(ChartCell *)chartCell tapType:(NSString *)tapType;
{    
    if ([tapType isEqualToString:@"atTa"]) {
        self.keyBordView.textField.text = [NSString stringWithFormat:@"@%@",chartCell.cellFrame.chartMessage.name];
    }else if ([tapType isEqualToString:@"copy"]) {
        self.keyBordView.textField.text = chartCell.cellFrame.chartMessage.content;
        [self.keyBordView keyPressed:nil];
    }else if ([tapType isEqualToString:@"back"]) {
        self.keyBordView.textField.text = [NSString stringWithFormat:@"回复%@:",chartCell.cellFrame.chartMessage.name];
    }else if ([tapType isEqualToString:@"viewThread"]) {
        if (self.threadView) {
            [self.threadView removeFromSuperview];
            self.threadView = nil;
        }
        
        self.threadView = [[[NSBundle mainBundle] loadNibNamed:@"ThreadView" owner:self
                                                      options:nil] objectAtIndex:0];
        [self.threadView.cancelBtn addTarget:self action:@selector(cancelThreadViewBtnAction:)
                            forControlEvents:UIControlEventTouchUpInside];
        //TODO:假数据
        NSMutableArray *dataArray = [NSMutableArray array];
        ChartMessage *cm = [[[ChartMessage alloc] init] autorelease];
        cm.icon = @"icon01.jpg";
        cm.name = @"里欧姆";
        cm.content = @"阿拉斯加地方垃圾是地方了几点睡了；房间";
        [dataArray addObject:cm];
        cm = [[[ChartMessage alloc] init] autorelease];
        cm.icon = @"icon01.jpg";
        cm.name = @"里欧姆";
        cm.content = @"啊水电费的萨芬啥的发大水发大水";
        [dataArray addObject:cm];
        cm = [[[ChartMessage alloc] init] autorelease];
        cm.icon = @"icon02.jpg";
        cm.name = @"天天甜甜";
        cm.content = @"而沿途有意u";
        [dataArray addObject:cm];
        cm = [[[ChartMessage alloc] init] autorelease];
        cm.icon = @"icon01.jpg";
        cm.name = @"里欧姆";
        cm.content = @"在新车先不买男变女没发育和";
        [dataArray addObject:cm];
        cm = [[[ChartMessage alloc] init] autorelease];
        cm.icon = @"icon02.jpg";
        cm.name = @"天天甜甜";
        cm.content = @"固原卡号给卡号给客户将客户";
        [dataArray addObject:cm];
        cm = [[[ChartMessage alloc] init] autorelease];
        cm.icon = @"icon02.jpg";
        cm.name = @"天天甜甜";
        cm.content = @"不v体育i";
        [dataArray addObject:cm];
        cm = [[[ChartMessage alloc] init] autorelease];
        cm.icon = @"icon01.jpg";
        cm.name = @"里欧姆";
        cm.content = @"擦擦擦不能那个和更大的:";
        [dataArray addObject:cm];
        
        self.threadView.dataArray = dataArray;
        [self.navigationController.view addSubview:self.threadView];
        
    }else if ([tapType isEqualToString:@"jubao"]) {
        //TODO:举报
    } if ([tapType isEqualToString:@"delete"]) {
        [self.tableView beginUpdates];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:chartCell];
        [self.cellFrames removeObjectAtIndex:indexPath.row];
        //TODO:访问删除接口
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

-(void)cancelThreadViewBtnAction:(id)sender
{
    [self.threadView removeFromSuperview];
    self.threadView = nil;
}

#pragma mark - KeyBordView

-(void)setKeyBordViewBlock
{
    __weak __block MainViewController *copy_self = self;
    
    [self.keyBordView setContentSizeBlock:^(CGSize contentSize) {
        [copy_self updateHeight:contentSize];
    }];
}

//更新约束
-(void)updateHeight:(CGSize)contentSize
{
    int updateTableView = 0;
    float height = contentSize.height;

    [self.view removeConstraint:self.keyBordViewConstraintHeight];
    NSString *string = [NSString stringWithFormat:@"V:[_keyBordView(%f)]", height];
    NSArray * tooViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:string options:0 metrics:0 views:NSDictionaryOfVariableBindings(_keyBordView)];
    
    if (self.keyBordViewConstraintHeight != tooViewConstraintV[0]) {
        updateTableView = 1;
    }
    
    self.keyBordViewConstraintHeight = tooViewConstraintV[0];
    [self.view addConstraint:self.keyBordViewConstraintHeight];
    
    if (updateTableView == 1) {
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height - height);
        [self tableViewScrollCurrentIndexPath];
        
        self.verticalScrollBar.frame = CGRectMake(self.verticalScrollBar.frame.origin.x, self.verticalScrollBar.frame.origin.y, self.verticalScrollBar.frame.size.width, self.view.frame.size.height-108-height);
        self.verticalScrollBar.backgroundImageView.frame = CGRectMake(0, 0, 8, self.verticalScrollBar.frame.size.height);
    }
}

- (void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextView *)textFiled
{
    ChartCellFrame *cellFrame=[[[ChartCellFrame alloc]init] autorelease];
    ChartMessage *chartMessage=[[[ChartMessage alloc]init] autorelease];
    
    int random=arc4random_uniform(2);
    NSLog(@"%d",random);
    chartMessage.icon=[NSString stringWithFormat:@"icon%02d.jpg",random+1];
    chartMessage.messageType=random;
    chartMessage.content=textFiled.text;
    cellFrame.chartMessage=chartMessage;
    
    [self.cellFrames addObject:cellFrame];
    [self.tableView reloadData];
    
    //滚动到当前行
    
    [self tableViewScrollCurrentIndexPath];
    textFiled.text=@"";
    
}

- (void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextView *)textFiled
{
    [self tableViewScrollCurrentIndexPath];
}

- (void)tableViewScrollCurrentIndexPath
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.cellFrames.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)beginRecord
{
    //设置为录音模式
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    bool ret = [_iFlySpeechRecognizer startListening];
}

-(void)cancelRecord
{
    [_iFlySpeechRecognizer cancel];
    [self.keyBordView.textField resignFirstResponder];
}

- (void)finishRecord
{
    [_iFlySpeechRecognizer stopListening];
}

#pragma mark - IFlySpeechRecognizerDelegate

- (void) onVolumeChanged: (int)volume
{
    NSLog(@"%@", [NSString stringWithFormat:@"音量：%d",volume]);
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 *
 * @see
 */
- (void) onBeginOfSpeech
{
    NSLog(@"正在录音");
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 *
 * @see
 */
- (void) onEndOfSpeech
{
    NSLog(@"停止录音");
}


/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    
    if (error.errorCode ==0 ) {
        text = @"识别成功";
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
    }
    
    [self.keyBordView changeToolView:0];
    NSLog(@"%@",text);
}

/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    //NSLog(@"听写结果：%@",resultString);
    
    self.iSRResult =[NSString stringWithFormat:@"%@%@", self.iSRResult,resultString];
    
    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
    
    self.keyBordView.textField.text = [NSString stringWithFormat:@"%@%@", self.keyBordView.textField.text, resultFromJson];
    [self.keyBordView.textField updateConstraints];
    
    if (isLast)
    {
//        NSLog(@"听写结果(json)：%@测试",  self.iSRResult);
//        NSLog(@"听写结果(Key)：%@测试",  resultFromJson);
        
        
//        [self KeyBordView:self.keyBordView textFiledBegin:self.keyBordView.textField];
//        [self.keyBordView.textField becomeFirstResponder];
        
        [self.keyBordView keyPressed:nil];
    }
}

/**
 * @fn      onCancel
 * @brief   取消识别回调
 * 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 * @param
 * @see
 */
- (void) onCancel
{
    NSLog(@"识别取消");
    
    [self.keyBordView changeToolView:0];
}

#pragma mark - IFlyDataUploaderDelegate

/**
 * @fn  onUploadFinished
 * @brief   上传完成回调
 * @param grammerID 上传用户词、联系人为空
 * @param error 上传错误
 */
- (void) onUploadFinished:(NSString *)grammerID error:(IFlySpeechError *)error
{
    NSLog(@"%d",[error errorCode]);
    
    if (![error errorCode]) {
        NSLog(@"上传成功");
    }
    else {
        NSLog(@"上传失败");
    }
}

#pragma mark - DropDownMenu

- (void)dropDownMenu:(id)sender {
    
    UIImage *dropImage = [UIImage imageNamed:@"drop_button_up.png"];
    dropImage = [UIImage imageWithCGImage:[dropImage CGImage] scale:2 orientation:(dropImage.imageOrientation)];
    [self.navMenuButton setImage:dropImage forState:UIControlStateNormal];
    
    MenuView *menuView1 = [[MenuView alloc] initWithFrame:CGRectMake(10, 0, 135, 50) title:@"特别关注"];
    MenuView *menuView2 = [[MenuView alloc] initWithFrame:CGRectMake(10, 0, 135, 50) title:@"相互关注"];
    MenuView *menuView3 = [[MenuView alloc] initWithFrame:CGRectMake(10, 0, 135, 50) title:@"同学朋友"];
    MenuView *menuView4 = [[MenuView alloc] initWithFrame:CGRectMake(10, 0, 135, 50) title:@"名人明星"];
    
    NSArray *arr = [NSArray arrayWithObjects:menuView1, menuView2, menuView3, menuView4, nil];
    self.popoverView = [[PopoverView showPopoverAtPoint:CGPointMake(160, 52) inView:self.navigationController.view withViewArray:arr delegate:self] retain];
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView {
    self.popoverView.delegate = nil;
    [_popoverView release];
    UIImage *dropImage = [UIImage imageNamed:@"drop_button_down.png"];
    dropImage = [UIImage imageWithCGImage:[dropImage CGImage] scale:2 orientation:(dropImage.imageOrientation)];
    [self.navMenuButton setImage:dropImage forState:UIControlStateNormal];
}

#pragma mark - ScrollBar
//
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    
    
    CGFloat contentHeight = [_tableView contentSize].height;
    CGFloat frameHeight = [_tableView frame].size.height;
    
    CGFloat contentOffsetY = [_tableView contentOffset].y > 0 ? ([_tableView contentOffset].y > contentHeight - frameHeight ? contentHeight - frameHeight : [_tableView contentOffset].y) : 0;
    
    CGFloat percent = (contentOffsetY / (contentHeight - frameHeight)) * 100;
    [[_accessoryView textLabel] setText:[NSString stringWithFormat:@"%i%%", (int)percent]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3f animations:^{
        [_accessoryView setAlpha:1.0f];
    }];
    
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.0];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_accessoryView setAlpha:0.0f];
    }];
}

@end
