//
//  DrawViewController.h
//  lovewith
//
//  Created by imqiuhang on 15/4/22.
//  Copyright (c) 2015年 imqiuhang All rights reserved.
//

#import "QHHead.h"

#import "DrawPaletteView.h"

@protocol DrawViewControllerDelegate <NSObject>

@optional
- (void)drawViewControllerDidMadeImage:(UIImage *)image;

@end

@interface DrawViewController : UIViewController

//需要研究的其实只有DrawPaletteView 这个VC只是一些 橡皮擦，选颜色之类的按钮的UI和选择事件

//这个VC因为包含了一些比较麻烦的视觉效果 所以代码看起来多一些，如果只是简单的画板 那么看@see DrawPaletteView的相关注释，只需要在改变颜色、粗细传入相关值就好了




@property (weak, nonatomic) IBOutlet DrawPaletteView *drawPaletteView;

@property (weak, nonatomic) IBOutlet UIButton *rubberBtn;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
@property (weak, nonatomic) IBOutlet UIView   *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *chooseWidthBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeColorBtn;

@property (nonatomic,weak)id<DrawViewControllerDelegate>delegate;


@property (nonatomic,strong)UIColor *currentPaintBrushColor;
@property (nonatomic)float currentPaintBrushWidth;

@end
