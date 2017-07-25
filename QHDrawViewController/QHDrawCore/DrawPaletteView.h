//
//  DrawPaletteView.h
//  lovewith
//
//  Created by imqiuhang on 15/4/22.
//  Copyright (c) 2015年 imqiuhang All rights reserved.
//

#import "QHHead.h"

@class DrawPaletteLineInfo;

@interface DrawPaletteView : UIView
{
@protected
    //哈希表暂存 在收到的哈希总数和实际收到的笔画数一致时表示 当前笔画存满 则将收到的所有同伴的笔画显示到画画上
    //暂时废弃，有时间会去实现相关的在线一起画的功能~
    NSMutableDictionary *partnerHashDrawQueue __deprecated_msg("在线一起画将会在有时间的时候加上，具体可以参考婚礼时光APP的在线一起画功能");
//-----------------------------------------------------------------------
    
}

//@set  从外部传递的 笔刷长度和宽度，在包含画板的VC中 要是颜色、粗细有所改变 都应该将对应的值传进来
@property (nonatomic,strong)UIColor *currentPaintBrushColor;
@property (nonatomic)float currentPaintBrushWidth;

//外部调用的清空画板和撤销上一步
- (void)cleanAllDrawBySelf;//清空画板
- (void)cleanFinallyDraw;//撤销上一条线条

@end

@interface DrawPaletteLineInfo : NSObject//一条线条所对应的线条的信息
//线条所包含的所有点
@property (nonatomic,strong)NSMutableArray <__kindof NSValue *> *linePoints;
@property (nonatomic,strong)UIColor *lineColor;//线条的颜色
@property (nonatomic)float lineWidth;//线条的粗细

@end




