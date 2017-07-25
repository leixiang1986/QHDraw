//
//  DrawViewController.m
//  lovewith
//
//  Created by imqiuhang on 15/4/22.
//  Copyright (c) 2015年 imqiuhang All rights reserved.
//

#import "DrawViewController.h"


@interface DrawViewController ()

@end

@implementation DrawViewController
{
    NSArray      *colorArr;
    UIScrollView *colorNavScrollView;
    UIView       *chooseWidthView;
    CGRect       changeWithViewDefaultFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"画";
    [self initColorBtn];
    [self initView ];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

//保存画板上的画
- (void)rightNavBtnEvent {
    if ([self.delegate respondsToSelector:@selector(drawViewControllerDidMadeImage:)]) {
        [self.delegate drawViewControllerDidMadeImage:[self.drawPaletteView screenshotWithQuality:1.f]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Gesture 
//屏蔽侧滑返回的触摸
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return  ![gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer];
}

#pragma mark- set
//设置笔刷的宽度 和颜色 并将设置好的值传给画板
- (void)setCurrentPaintBrushColor:(UIColor *)currentPaintBrushColor {
    _currentPaintBrushColor= currentPaintBrushColor;
    self.drawPaletteView.currentPaintBrushColor = currentPaintBrushColor;
}

- (void)setCurrentPaintBrushWidth:(float)currentPaintBrushWidth {
    _currentPaintBrushWidth = currentPaintBrushWidth;
    self.drawPaletteView.currentPaintBrushWidth = currentPaintBrushWidth;
}

#pragma mark - ValueChangedEvent
//点击了改变颜色滑动栏上的某个颜色按钮，讲选择好的颜色传给画板
- (void)colorBtnEvent:(UIButton *)sender {
    self.currentPaintBrushColor = [QHUtil colorWithHexString:colorArr[sender.tag]];
    self.rubberBtn.tag = 0;
    [self.rubberBtn setImage:[UIImage imageNamed :@"icon_runbbsh_gray@3x"] forState:UIControlStateNormal];
    [self changeColor:self.changeColorBtn];
}

//点击了橡皮  临时将画板上的画笔颜色改为白色，取消点击橡皮后再将原本的颜色传给画笔
- (IBAction)rubberBtnEvent:(id)sender {
    if (self.rubberBtn.tag==0) {
        self.drawPaletteView.currentPaintBrushColor = [QHUtil colorWithHexString:@"ffffff"];
        self.rubberBtn.tag=1;
        [self.rubberBtn setImage:[UIImage imageNamed :@"icon_runbbsh_pink"] forState:UIControlStateNormal];
    }else {
        self.rubberBtn.tag = 0;
        self.currentPaintBrushColor = _currentPaintBrushColor;
        [self.rubberBtn setImage:[UIImage imageNamed :@"icon_runbbsh_gray@3x"] forState:UIControlStateNormal];
    }
    
}

//撤销一步的操作，貌似需求不需要了
- (IBAction)backBtnEvent:(id)sender {
    [self.drawPaletteView cleanFinallyDraw];
}

//清空画板按钮
- (IBAction)cleanBtnEvent:(id)sender {
    AlertViewWithBlockOrSEL *alertView = [[AlertViewWithBlockOrSEL alloc] initWithTitle:@"清空画板" message:@"确定清空自己的画板?这将无法撤销."] ;
    [alertView addOtherButtonWithTitle:@"清空" onTapped:^{
        [self.drawPaletteView cleanAllDrawBySelf];
    }];
    [alertView setCancelButtonWithTitle:@"取消" onTapped:^{
    }];
    [alertView show];

}

//弹出选颜色的滑动栏
- (IBAction)changeColor:(UIButton *)sender {
    sender.enabled = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        colorNavScrollView.width =  colorNavScrollView.width<QHScreenWidth?QHScreenWidth:0;
    } completion:^(BOOL finished) {
        sender.enabled = YES;
        
    }];
}

//弹出选择粗细的按钮
- (IBAction)chageWidth:(UIButton *)sender {
    
    sender.enabled=NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (chooseWidthView.height>0) {
            chooseWidthView.height=0;
            chooseWidthView.bottom = self.view.bottom-self.bottomView.height;
        }else {
            chooseWidthView.frame = changeWithViewDefaultFrame;
        }
    } completion:^(BOOL finished) {
        sender.enabled = YES;
        
    }];
}

//选择粗细按钮上的某个粗细按钮点击事件，将选择好的粗细传给画板
- (void)selectWidth:(int)index {
    for(UIButton *btn in chooseWidthView.subviews) {
        if (btn.tag==index) {
            btn.backgroundColor = QHRGB(255, 100, 153);;
        }else {
            btn.backgroundColor = QHRGB(216, 216, 316);;
        }
    }
    self.currentPaintBrushWidth = (index+1);
    
}

- (void)widthBtnEvent:(UIButton *)sender {
    [self selectWidth:(int)sender.tag];
    [self chageWidth:self.chooseWidthBtn];
}


#pragma mark -init
- (void)initColorBtn {
    
    [self.view addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];

    colorArr = @[
      @"#ffc0cb",
      @"#fb0d0d",
      @"#d65303",
      @"#d69803",
      @"#d6d403",
      @"#acd603",
      @"#4ed603",
      @"#03d666",
      @"#03d6c0",
      @"#03b6d6",
      @"#0366d6",
      @"#2b03d6",
      @"#7a03d6",
      @"#bb03d6",
      @"#d603ac",
      @"#d6036b",
    ];

    float margin              = 20.f;
    float colorSliderNavHeigh = 44.f;
    float colorBtnWidth       = 30.f;
    float colorBtnmargin      = 10;
    
    
    colorNavScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, QHScreenWidth, colorSliderNavHeigh)];
    colorNavScrollView.bottom = self.view.height-self.bottomView.height;
    colorNavScrollView.contentSize =CGSizeMake(margin*2+colorBtnWidth*colorArr.count+colorBtnmargin*(colorArr.count-1), colorNavScrollView.contentSize.height);
    colorNavScrollView.showsVerticalScrollIndicator   = NO;
    colorNavScrollView.showsHorizontalScrollIndicator = NO;
    colorNavScrollView.bounces                        = YES;
    [self.view addSubview:colorNavScrollView];
    colorNavScrollView.width = 0;
    
    for (int i=0; i<colorArr.count; i++) {
        UIButton *colorBtn          = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, colorBtnWidth, colorBtnWidth)];
        colorBtn.left               = margin+i*colorBtnWidth+i*colorBtnmargin;
        colorBtn.centerY            = colorNavScrollView.height/2.f;
        colorBtn.tintColor          = [QHUtil colorWithHexString:colorArr[i]];
        [colorBtn setImage:[[UIImage imageNamed:@"icon_draw_color_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        colorBtn.tag                = i;
        [colorNavScrollView addSubview:colorBtn];
        [colorBtn addTarget:self action:@selector(colorBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        colorBtn.layer.cornerRadius = colorBtn.height/2.f;
    }
    
}

- (void)initView {

    self.rubberBtn.tag = 0;
    self.currentPaintBrushColor = [QHUtil colorWithHexString:colorArr[0]] ;
    self.currentPaintBrushWidth = 4;
    self.drawPaletteView.layer.borderWidth = 0.5;
    self.drawPaletteView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.drawPaletteView.layer.masksToBounds = YES;
    self.drawPaletteView.backgroundColor     = [UIColor whiteColor];
    self.bottomView.backgroundColor          = [QHUtil colorWithHexString:@"#DDDDDD"];
    
    float wwidth               = 32;
    chooseWidthView            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wwidth, wwidth*3+3*6)];
    chooseWidthView.centerX    = self.chooseWidthBtn.centerX;
    chooseWidthView.bottom     = self.view.bottom-self.bottomView.height;
    [self.view addSubview:chooseWidthView];
    changeWithViewDefaultFrame = chooseWidthView.frame;
    chooseWidthView.height     = 0;
    chooseWidthView.bottom     = self.view.bottom-self.bottomView.height;
    chooseWidthView.clipsToBounds=YES;
    for (int i=0;i<3;i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0+i*(6+wwidth), wwidth, wwidth)];
        btn.backgroundColor = [QHUtil colorWithHexString:@"#D8D8D8"];
        btn.tag=2-i;
        [btn addTarget:self action:@selector(widthBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8+btn.tag*4,  8+btn.tag*4)];
        view.backgroundColor        = [UIColor whiteColor];
        view.userInteractionEnabled = NO;
        view.centerX                = btn.width/2.f;
        view.centerY                = btn.height/2.f;
        view.layer.cornerRadius     = view.width/2.f;
        [btn addSubview:view];
        [chooseWidthView addSubview:btn];
        
    }
    
    [self selectWidth:1];
    
    
    UIButton *  rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightNavBtn setTitle:@"生成" andFont:defaultFont(16) andTitleColor:YMSTitleColor andBgColor:[UIColor clearColor] andRadius:0];
    
    rightNavBtn.size = CGSizeMake(80, 30);
    rightNavBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightNavBtn addTarget:self
                    action:@selector(rightNavBtnEvent)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];

    
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
}




@end
